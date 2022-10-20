import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:notesqflite/models/notemodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Notehelper {
  late Database db;

  Future openDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);
    db = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE IF NOT EXISTS $tableName (
              $columnId INTEGER PRIMARY KEY,
              $headTitle TEXT NOT NULL,
              $bodyTitle TEXT NOT NULL,
              )
          ''');
  }

  Future<NoteModel> insert(NoteModel noteModel) async {
    noteModel.id = await db.insert(tableName, noteModel.toMap);
    return noteModel;
  }

  Future<int> update(NoteModel noteModel) async {
    return await db.update(
      tableName,
      noteModel.toMap,
      where: '$columnId=?',
      whereArgs: [noteModel.id],
    );
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: '$columnId=?',
      whereArgs: [id],
    );
  }

  Future<List<NoteModel>> selectAll() async {
    List list = await db.query(tableName);
    return compute(_parseData, list);
  }

  Future close() async => db.close();

  Future<List<Map<String, Object?>>> rawQuery(String sql) {
    return db.rawQuery(sql);
  }
}

List<NoteModel> _parseData(List list) {
  return list.map((e) => NoteModel.fromMap(e)).toList();
}
