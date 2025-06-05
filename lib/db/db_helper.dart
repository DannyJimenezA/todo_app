import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

Future<Database> _initDB() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'tasks.db');

  final db = await openDatabase(
    path,
    version: 2, 
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          isCompleted INTEGER
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE tasks ADD COLUMN isCompleted INTEGER DEFAULT 0');
      }
    },
  );

  return db;
}


  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTaskCompletion(Task task) async {
  final db = await database;
  return await db.update(
    'tasks',
    {'isCompleted': task.isCompleted ? 1 : 0}, 
    where: 'id = ?',
    whereArgs: [task.id],
  );
}

}
