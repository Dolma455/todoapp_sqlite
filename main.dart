import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sqlite/app/app.dart';
import 'package:todo_sqlite/todo_app/screen/items_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemsList(),
      child: const MyApp(),
    ),
  );
}
