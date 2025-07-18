import 'package:flutter/material.dart';

class EventDashboardScreen extends StatefulWidget {
  const EventDashboardScreen({super.key});

  @override
  State<EventDashboardScreen> createState() => _EventDashboardState();
}

class _EventDashboardState extends State<EventDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Dashboard"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Created"),
            Tab(text: "Interested"),
            Tab(text: "Attended"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          EventListTab(type: 'created'),
          EventListTab(type: 'interested'),
          EventListTab(type: 'attended'),
        ],
      ),
    );
  }
}

class EventListTab extends StatelessWidget {
  final String type;

  const EventListTab({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        title: Text("Event $index - $type"),
        subtitle: const Text("Date: YYYY-MM-DD"),
        trailing: type == 'attended'
            ? Switch(
                value: true,
                onChanged: (v) {},
              )
            : null,
      ),
    );
  }
}
