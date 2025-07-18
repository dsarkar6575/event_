import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/controllers/authProvider.dart';
import 'package:myapp/screen/auth/loginScreen.dart';
import 'package:myapp/screen/chat/chat_screen.dart';
import 'package:myapp/screen/event/event_dashboard.dart';
import 'package:myapp/screen/event/post_event_creation_screen.dart';
import 'package:myapp/screen/feed/home_feed_screen.dart';
import 'package:myapp/screen/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const HomeFeedScreen(),
    ChatScreen(),
    const CreatePostScreen(),
    const EventDashboardScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // 🔐 If not logged in, redirect to LoginScreen
    if (!authProvider.isLoggedIn) {
      // Avoid build errors by scheduling navigation
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });

      // Show empty screen temporarily
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ If logged in, show dashboard
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add Event'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
