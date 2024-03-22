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
    await database.execute("""CREATE TABLE Servicios(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT,
        descripcion TEXT, 
        tiempoMinutos INTEGER
      )
      """);
    await database.execute("""CREATE TABLE Paquetes(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT,
        descripcion TEXT
      )
      """);
    await database.execute("""CREATE TABLE Paquetes_Servicios(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_Paquete INTEGER,
        id_Servicio INTEGER,
        FOREIGN KEY(id_Paquete) REFERENCES Paquetes(id),
    FOREIGN KEY(id_Servicio) REFERENCES Servicios(id)
      )
      """);
    await database.execute("""CREATE TABLE Colaboradores(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT
        )""");
    await database.execute("""CREATE TABLE Citas(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        detalle TEXT,
        fecha TEXT,
        hora TEXT,
        estado TEXT,
        id_Usuario INTEGER,
        id_Paquete INTEGER,
        id_Colaborador INTEGER,
        FOREIGN KEY(id_Usuario) REFERENCES Usuario(id),
        FOREIGN KEY(id_Paquete) REFERENCES Paquetes(id),
        FOREIGN KEY(id_Colaborador) REFERENCES Colaboradores(id)
        )""");

        await database.execute("""INSERT INTO Colaboradores
        (nombre) VALUES ("Simon Bolibar"),
        ("Juan Perez"),
        ("Maria Lopez"),
        ("Pedro Ramirez")
        """);

        await database.execute("""INSERT INTO Servicios (nombre,descripcion,tiempoMinutos) VALUES 
        ("Corte de pelo", "Se le cortara el pelo", 32),
        ("Secado de Pelo", "Se le quitara la humedad al pelo", 15),
        ("Peinado", "Se le peinara el pelo", 40),
        ("Cortar Uñas", "Se le cortara las uñas", 30),
        ("Pintar Uñas", "Se le pintaran las uñas al gusto", 60)
      """);

      await database.execute("""INSERT INTO Paquetes
      (nombre,descripcion) VALUES 
      ("Blower", "Se hara un trabajo espectacular"),
      ("Estilo de Uñas", "Quedaran lindas")
      """);

      await database.execute("""INSERT INTO Paquetes_Servicios(
        id_Paquete,
        id_Servicio) VALUES
        (1,1),
        (1,2),
        (1,3),
        (2,4),
        (2,5)
      """);

      await database.execute("""INSERT INTO Usuario(
        nombre,
        correo,
        instagram,
        telefono,
        contrasena
      ) VALUES ("Joselito", "jose@gmail.com", "josuel_xxx", "3015648374", "jose1234")
      """);

      await database.execute("""INSERT INTO Citas(
        detalle,
        fecha,
        hora,
        estado,
        id_Usuario,
        id_Paquete,
        id_Colaborador
        ) VALUES 
        ("Quiero que sean amable conmigo cuando me corten el pelo, tengo miedo", "13/04/2024", "16:30", "En espera", 1, 1, 1)
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

  // Create new usuario in the database
  static Future<int> createLibros(String nombre, String? correo,
      String? instagram, String? telefono, String contrasena) async {
    final db = await SQLHelper.db();

    final data = {
      'nombre': nombre,
      'correo': correo,
      'instagram': instagram,
      'telefono': telefono,
      'contrasena': contrasena
    };
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
  static Future<int> actualizarLibros(int id, String nombre, String? correo,
      String? instagram, String? telefono, String? contrasena) async {
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
