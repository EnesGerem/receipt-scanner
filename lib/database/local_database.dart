import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:receipt_scanner/models/receipt.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Receipt ("
          "id INTEGER PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT"
          ")");
    });
  }

  newReceipt(Receipt newReceipt) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Receipt");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Receipt (id,first_name,last_name)"
        " VALUES (?,?,?)",
        [id, newReceipt.firstName, newReceipt.lastName]);
    return raw;
  }

  updateReceipt(Receipt newReceipt) async {
    final db = await database;
    var res = await db.update("Receipt", newReceipt.toMap(),
        where: "id = ?", whereArgs: [newReceipt.id]);
    return res;
  }

  getReceipt(int id) async {
    final db = await database;
    var res = await db.query("Receipt", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Receipt.fromMap(res.first) : null;
  }

  Future<List<Receipt>> getAllReceipts() async {
    final db = await database;
    var res = await db.query("Receipt");
    List<Receipt> list =
        res.isNotEmpty ? res.map((c) => Receipt.fromMap(c)).toList() : [];

    return list;
  }

  deleteReceipt(int id) async {
    final db = await database;
    return db.delete("Receipt", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    await db.rawDelete("Delete * from Receipt");
  }
}
