import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
   ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Center(
        child: Text('Chat Module Content'),
      ),
    );
  }
}