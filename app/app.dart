import 'package:flutter/material.dart';
import 'package:todo_sqlite/todo_app/screen/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ItemsPage(),
    );
  }
}