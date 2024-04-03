import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citasCreate.dart';
import 'package:flutteralexasoft/main.dart';
import 'package:flutteralexasoft/sqlhelper.dart';

int contadorCitas = 0;

class Citas extends StatelessWidget {
  const Citas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlexaSoft Team',
      theme: ThemeData(
        fontFamily: 'Raleway',
        colorScheme: const ColorScheme.dark(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 59, 59, 59),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: const CitasPage(),
    );
  }
}

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  int? userId;
  List<Map<String, dynamic>> citas = [];

  @override
  void initState() {
    super.initState();
    obtenerIdUsuario();
    obtenerCitas();
    contadorCitas = 0;
  }

  Future<void> obtenerCitas() async {
    final List<Map<String, dynamic>> listaCitas =
        await SQLHelper.obtenerCitas(1);
    setState(() {
      citas = listaCitas;
    });
  }

  Future<List<Map<String, dynamic>>> obtenerServiciosPaquete(
      int idPaquete) async {
    return await SQLHelper.obtenerServiciosPaquete(idPaquete);
  }

  Future<void> obtenerIdUsuario() async {
    final user = await SQLHelper.obtenerUsuariosInicioSesion('correo',
        'contrasena'); // Reemplaza 'correo' y 'contrasena' con las credenciales del usuario
    setState(() {
      userId = user.isNotEmpty ? user[0]['id'] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset("assets/logobarrasf.png", width: 250)),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 38),
            ListTile(
              title: Image.asset("assets/logobarrasf.png"),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Citas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Citas(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: Text(
                      'Citas',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  )),
              citas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'No tienes citas todavia',
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: citas.map((cita) {
                        contadorCitas += 1;
                        return Center(
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: obtenerServiciosPaquete(cita['id_paquete']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final serviciosPaquete = snapshot.data ?? [];
                                return GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Detalles de la cita'),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Cita ${cita['id']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                              SizedBox(height: 10),
                                              Text('Fecha: ${cita['fecha']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text('Hora: ${cita['hora']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text('Estado: ${cita['estado']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text(
                                                  'Usuario: ${cita['nombre_usuario']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text(
                                                  'Paquete: ${cita['nombre_paquete']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text(
                                                  'Descripción del paquete: ${cita['descripcion_paquete']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text('Servicios:',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  for (var servicio
                                                      in serviciosPaquete)
                                                    Text(
                                                        '- ${servicio['nombre']}',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                ],
                                              ),
                                              Text(
                                                  'Descripción del servicio: ${cita['descripcion_servicio']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text(
                                                  'Colaborador: ${cita['nombre_colaborador']}',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cerrar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    elevation: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0,
                                          top: 20,
                                          bottom: 20,
                                          right: 120.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cita $contadorCitas',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            'Fecha: ${cita['fecha']}',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            'Hora: ${cita['hora']}',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            'Estado: ${cita['estado']}',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarCitas()),
          );
        },
        backgroundColor: Color.fromARGB(255, 27, 29, 29),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // showConfirmDelete(BuildContext context) {
  //   Widget cancelButton = ElevatedButton(
  //     child: Text("Cancelar"),
  //     style: ButtonStyle(
  //       shape: MaterialStateProperty.all(
  //         RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //     ),
  //     onPressed: () {
  //       print("Cancelando..");
  //       Navigator.of(context).pop();
  //     },
  //   );
  //   Widget continueButton = ElevatedButton(
  //     child: Text("Eliminar"),
  //     style: ButtonStyle(
  //       shape: MaterialStateProperty.all(
  //         RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //     ),
  //     onPressed: () {
  //       print("Eliminando..");
  //       // Otras acciones de eliminar
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Eliminar cuenta"),
  //     content: Text("¿Estás seguro de eliminar permanentemente tu cuenta?"),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
