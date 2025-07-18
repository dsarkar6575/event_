import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/constrains.dart';
import 'package:myapp/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  int _page = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  /// Create a new post (can be event-based)
  Future<String?> createPost({
    required String title,
    required String description,
    required String place,
    required DateTime eventDateTime,
    required List<File> images,
  }) async {
    const String _postApi = "posts";

    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        return 'User not authenticated';
      }

      final uri = Uri.parse("$baseApi$_postApi");
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['content'] = "$title\n$description"
        ..fields['place'] = place
        ..fields['eventDateTime'] = eventDateTime.toIso8601String();

      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 201) {
        return null; // success
      } else {
        debugPrint("Post Error Response: $responseBody");
        return 'Error: ${streamedResponse.statusCode} - $responseBody';
      }
    } catch (e) {
      debugPrint("Post Exception: $e");
      return 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPosts() async {
  if (!_hasMore || _isLoading) return;

  const String _postApi = "posts";
  _isLoading = true;
  notifyListeners();

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse('$baseApi$_postApi?page=$_page&limit=10');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['posts'] != null && responseData['posts'] is List) {
        List<Post> fetchedPosts = (responseData['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();

        _posts.addAll(fetchedPosts);
        _page++;
        _hasMore = fetchedPosts.length == 10;
      } else {
        throw Exception('Invalid posts data received');
      }
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  } catch (error) {
    debugPrint('❌ Error loading posts: $error');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
/// Refresh the post list (reset page and refetch)
Future<void> refreshPosts() async {
  _posts.clear(); // Clear existing posts
  _page = 1;       // Reset page
  _hasMore = true; // Reset pagination flag
  await fetchPosts(); // Fetch the first page again
}


}
