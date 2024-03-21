import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {

  
static Future<void> createTables(sql.Database database) async {
   

    await database.execute("""CREATE TABLE Usuario(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT,
        correo TEXT,
        instagram TEXT,
        telefono TEXT,
        contrasena TEXT
      )
      """);
  }
  
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'bookstore.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createLibros(String nombre, String? correo, String? instagram, String? telefono, String contrasena) async {
    final db = await SQLHelper.db();

    final data = {'nombre': nombre, 'correo': correo, 'instagram': instagram, 'telefono': telefono , 'contrasena': contrasena};
    final id = await db.insert('Usuario', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> obtenerLibros() async {
    final db = await SQLHelper.db();
    return db.query('Usuario', orderBy: "id");
  }

    static Future<List<Map<String, dynamic>>> obtenerLibro(int id) async {
    final db = await SQLHelper.db();
    return db.query('Usuario', where: "id = ?", whereArgs: [id], limit: 1);
  }


  // Update an item by id
  static Future<int> actualizarLibros(
      int id, String nombre, String? correo, String? instagram, String? telefono, String? contrasena) async {
    final db = await SQLHelper.db();

    final data = {
      'nombre': nombre,
      'correo': correo,
      'instagram': instagram,
      'telefono': telefono,
      'contrasena': contrasena
    };

    final result =
        await db.update('Usuario', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> eliminarLibros(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("Usuario", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Se ha eliminado el Usuario: $err");
    }
  }
}