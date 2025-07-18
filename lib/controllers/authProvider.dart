import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/constrains.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class AuthProvider extends ChangeNotifier {
  // Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Register Endpoint Path
  final String _registerUrl = "auth/register";

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  /// Registers a new user
  Future<http.Response> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final Uri url = Uri.parse("$baseApi$_registerUrl");
    print("POST: $url");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      print("Response ${response.statusCode}: ${response.body}");
      return response;
    } catch (e) {
      print("Registration error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // TODO: Add login method

  // Add this inside your AuthProvider class

Future<http.Response> login(String email, String password) async {
  _isLoading = true;
  notifyListeners();

  final String _loginUrl = "auth/login";

  final Uri url = Uri.parse("$baseApi$_loginUrl");
  print("POST: $url");

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print("Login Response ${response.statusCode}: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _isLoggedIn = true;
      // Save token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', responseData['token']);
    }

    return response;
  } catch (e) {
    print("Login error: $e");
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}