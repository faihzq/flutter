import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:assessment/models/post.dart';
import 'package:assessment/models/comment.dart';
import 'package:assessment/post_details.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  late List<Post> posts;
  List<Post> filteredPosts = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void _filterPosts(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredPosts = posts
          .where(
            (post) =>
                post.title.toLowerCase().contains(query) ||
                post.body.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  void _navigateToPostDetails(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetails(
                post,
                fetchPostDetails,
                fetchComments,
              )),
    );
  }

  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        posts = responseData.map((data) => Post.fromJson(data)).toList();
        filteredPosts = posts;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> fetchPostDetails(int postId) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return Post.fromJson(responseData);
    } else {
      throw Exception('Failed to load post details');
    }
  }

  Future<List<Comment>> fetchComments(int postId) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/comments?postId=$postId'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Posts List',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPosts,
              decoration: InputDecoration(
                  hintText: 'Search',
                  fillColor: Color.fromARGB(255, 236, 234, 234),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                    subtitle: Text(post.body),
                    onTap: () {
                      _navigateToPostDetails(post);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
