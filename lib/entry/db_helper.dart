import 'dart:io';

import 'package:answer/entry/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._internal() {
    database; //初始化数据库
  }

  static final _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  //初始化数据库方法
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user_database.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
            CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, password TEXT)
            ''');
    });
  }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      print(_database);
      return _database!;
    }

    _database = await initDB();
    print("创建新数据库");
    return _database!;
  }

  ///插入数据
  Future<int> insertUser(User comer) async {
    final Database db = await database;
    /// 先查询 防止重名
    User? user = await queryDatabaseByName(comer.name);
    if (user != null) {
      return -1;
    }

    var result = await db.insert(
      'users',
      comer.toJson(),
      //插入冲突策略，新的替换旧的
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  ///查询数据
  Future<User?> queryDatabaseByName(String name) async {
    final Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('users',
        columns: ['name', 'password'], where: 'name = ?', whereArgs: [name]);
    if (maps.isNotEmpty) {
      print("根据id查到了数据");
      User user = User.fromJson(maps.first);
      print("单用户查询成功");
      print('the name is : ' + user.name.toString());
      return user;
    }
    return null;
  }
}
