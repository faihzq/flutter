import 'package:flutter/material.dart';

import 'package:assessment/posts_list.dart';

void main() {
  runApp(MaterialApp(
    title: 'Post',
    theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightGreen,
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 23))),
    home: const PostsList(),
  ));
}
