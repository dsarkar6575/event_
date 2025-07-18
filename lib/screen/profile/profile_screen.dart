import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isOwnProfile;

  const ProfileScreen({super.key, this.isOwnProfile = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isOwnProfile ? "My Profile" : "User Profile")),
      body: ListView(
        children: [
          const CircleAvatar(radius: 40, backgroundImage: NetworkImage("https://via.placeholder.com/150")),
          const SizedBox(height: 10),
          const Center(child: Text("John Doe")),
          const Center(child: Text("Bio goes here...")),
          if (isOwnProfile)
            TextButton(onPressed: () {
              // Navigate to edit profile
            }, child: const Text("Edit Profile")),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Timeline", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Dummy Timeline Posts
          
        ],
      ),
    );
  }
}
