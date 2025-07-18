import 'package:flutter/material.dart';
import 'package:myapp/controllers/authProvider.dart';
import 'package:myapp/controllers/postProvider.dart';
import 'package:myapp/screen/auth/loginScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: [
      ChangeNotifierProvider(create:(_)=> AuthProvider()),
      ChangeNotifierProvider(create:(_)=> PostProvider())
    ],
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMS',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
    )
    );
  }
}

