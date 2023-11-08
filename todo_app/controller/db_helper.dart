import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Future<Database> initializeDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "my_todo_app.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE item11 (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   name TEXT NOT NULL,
   description TEXT NOT NULL
   )
''');
      },
    );
  }
}
