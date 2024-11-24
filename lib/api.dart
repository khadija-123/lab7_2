import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map<String, dynamic>? _post;
  bool _isLoading = false;

  Future<void> _fetchPost() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _post = json.decode(response.body); // Decode JSON
          _isLoading = false; // Stop loading
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showError("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError("An error occurred: $e");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fetch API Data"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show spinner while loading
            : _post != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Post ID: ${_post!['id']}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Title: ${_post!['title']}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Body: ${_post!['body']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: _fetchPost,
                    child: const Text("Fetch Post"),
                  ),
      ),
    );
  }
}
