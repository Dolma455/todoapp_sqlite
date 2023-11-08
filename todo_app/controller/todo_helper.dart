import 'package:sqflite/sqflite.dart';
import 'package:todo_sqlite/todo_app/controller/db_helper.dart';
import 'package:todo_sqlite/todo_app/model/db_model.dart';
import 'package:todo_sqlite/todo_app/screen/items_list.dart';

class TodoHelper {
  Future<void> insertItem(Items item) async {
    final db = await DBHelper().initializeDB();
    await db.insert(
      'item11',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await DBHelper().initializeDB();
    await db.delete('item11', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateItem(Items items) async {
    final db = await DBHelper().initializeDB();
    final data = await db
        .update('item11', items.toMap(), where: 'id=?', whereArgs: [items.id]);
    return data;
  }

  Future<List<Items>> getItems() async {
    final db = await DBHelper().initializeDB();
    final data = await db.query('item11');
    return List.from(data).map((e) => Items.fromMap(e ?? {})).toList();
  }

  
  Future<void> addItem(Items item) async {
    ItemsList().items.add(item);
    await insertItem(item);
  }

  List<Items> selectedItems = [];

  Future<void> deleteItems(Items item) async {
    await deleteItem(item.id!);
    ItemsList().items.removeWhere((items) => items.id == item.id);
    selectedItems.removeWhere((element) => element.id == item.id);
  }

  Future<void> updateItems(
    String title,
    String desc,
    int id,
  ) async {
    Items updatedItem = Items(
      id: id,
      name: title,
      description: desc,
    );
    await getItems();
    await updateItem(updatedItem);
  }

    void toggleCheckbox(
    Items item,
    List<Items> selectedItems,
    List<int> clickedIndex,
    Function setStateCallback,
  ) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
      clickedIndex.remove(item.id!);
    } else {
      selectedItems.add(item);
      clickedIndex.add(item.id!);
    }

    setStateCallback();
  }

    Future<void> deleteMultipleItems(List<int> itemIds) async {
    for (var id in itemIds) {
      await deleteItem(id);
    }
  }


}
