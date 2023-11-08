import 'package:flutter/material.dart';

import 'package:todo_sqlite/todo_app/model/db_model.dart';

class ItemsList extends ChangeNotifier {
  List<Items> items = [];
}
