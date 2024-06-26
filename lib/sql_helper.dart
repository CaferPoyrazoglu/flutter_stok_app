import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        stok INTEGER,
        barkod TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'stokapp.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(
      String title, String? descrption, String? stok, String? barkod) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'stok': stok,
      'barkod': barkod
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String title, String? descrption,
      int? stok, String? barkod) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'stok': stok,
      'barkod': barkod,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static satisYap(String barkod, int adet) async {
    final db = await SQLHelper.db();
    int? asilStok;
    // ignore: prefer_typing_uninitialized_variables
    var result;

    // ignore: unused_local_variable
    var sorgu = await db
        .query('items', where: "barkod = ?", whereArgs: [barkod]).then((value) {
      // ignore: avoid_print
      asilStok = int.parse(value[0].entries.elementAt(3).value.toString());
      // ignore: avoid_print
      print(asilStok);
    });

    final data = {
      'stok': asilStok! - adet,
      'barkod': barkod,
      'createdAt': DateTime.now().toString()
    };

    result = db.update('items', data, where: "barkod = ?", whereArgs: [barkod]);

    return result;
  }
}
