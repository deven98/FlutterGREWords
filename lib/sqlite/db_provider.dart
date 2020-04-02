import 'dart:async';
import 'dart:io';

import 'package:flutter_gre/data/word.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "WordDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Words ("
            "word_name TEXT PRIMARY KEY,"
            "word_definition TEXT"
            ")");
      },
    );
  }

  insertWord(Word word) async {
    final db = await database;
    var res = await db.insert("Words", word.toJson());
  }

  Future<List<Word>> getAllWords() async {
    final db = await database;
    var res = await db.query("Words");
    List<Word> list =
        res.isNotEmpty ? res.map((c) => Word.fromJson(c)).toList() : [];
    return list;
  }
}
