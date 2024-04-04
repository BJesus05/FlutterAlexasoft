// ignore_for_file: non_constant_identifier_names

import 'dart:core';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

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

    await database.execute(
        """INSERT INTO Servicios (nombre,descripcion,tiempoMinutos) VALUES
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
      ) VALUES ("Joselito", "jose@gmail.com", "josuel_xxx", "3015648374", "Jose1234#")
      """);

    /* await database.execute("""INSERT INTO Citas(
        detalle,
        fecha,
        hora,
        estado,
        id_Usuario,
        id_Paquete,
        id_Colaborador
        ) VALUES
        ("Quiero que sean amable conmigo cuando me corten el pelo, tengo miedo", "13/04/2024", "16:30", "En espera", 1, 1, 1),
        ("Hay final triste", "17/04/2024", "01:30", "En espera", 1, 2, 3)
        """); */
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'alexasoft.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new usuario in the database
  static Future<int> CrearUsuario(String nombre, String? correo,
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

  static Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final db = await SQLHelper.db();
    return db.query('Usuario', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> obtenerColaboradores() async {
    final db = await SQLHelper.db();
    return db.query('Colaboradores', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> obtenerPaquetes() async {
    final db = await SQLHelper.db();
    return db.rawQuery('''
    SELECT * FROM Paquetes
  ''');
  }

  static Future<List<Map<String, dynamic>>> obtenerCitas(int? id) async {
  final db = await SQLHelper.db();
  return db.rawQuery('''
    SELECT DISTINCT Citas.id, Citas.detalle, Citas.fecha, Citas.hora, Citas.estado, 
       Usuario.nombre AS nombre_usuario,
       Paquetes.id AS id_paquete, Paquetes.nombre AS nombre_paquete,
       Colaboradores.nombre AS colaborador
FROM Citas
JOIN Usuario ON Citas.id_Usuario = Usuario.id
JOIN Paquetes ON Citas.id_Paquete = Paquetes.id
LEFT JOIN Colaboradores ON Citas.id_Colaborador = Colaboradores.id
WHERE Citas.id_Usuario = $id;
  ''');
}

  static Future<List<Map<String, dynamic>>> obtenerServiciosPaquete(int? idPaquete) async {
    final db = await SQLHelper.db();
    return db.rawQuery('''
    SELECT Servicios.nombre
FROM Paquetes_Servicios
JOIN Servicios ON Paquetes_Servicios.id_Servicio = Servicios.id
WHERE Paquetes_Servicios.id_Paquete = $idPaquete;

  ''');
  }

  static Future<List<Map<String, dynamic>>> obtenerUsuario(int id) async {
    final db = await SQLHelper.db();
    return db.query('Usuario', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> obtenerUsuariosInicioSesion(
      String correo, String contrasena) async {
    final db = await SQLHelper.db();
    return db.query('Usuario',
        where: "correo = ? AND contrasena = ?",
        whereArgs: [correo, contrasena],
        limit: 1);
  }

  static Future<void> guardarCita(
      String detalle, DateTime fecha, int colaborador, int? userId, int idPaquete) async {
        String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
  String horaFormateada = DateFormat('HH:mm').format(fecha);
    final db = await SQLHelper.db();
    await db.insert('Citas', {
      'detalle': detalle,
      'fecha': fechaFormateada,
      'hora' : horaFormateada,
      'id_Usuario': userId,
      'id_Paquete' : idPaquete,
      'id_Colaborador' : colaborador,
      'estado' : 'En espera'
    });
  }
  static Future<bool> verificarCorreoExistente(String correo) async {
  final db = await SQLHelper.db();
  final result = await db.rawQuery('SELECT COUNT(*) AS count FROM Usuario WHERE correo = ?', [correo]);
  final count = Sqflite.firstIntValue(result)!;
  return count > 0; 
}
}
