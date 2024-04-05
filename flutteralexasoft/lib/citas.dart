// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citasCreate.dart';
import 'package:flutteralexasoft/main.dart';
import 'package:flutteralexasoft/sqlhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor:Color.fromARGB(255, 199, 152, 70)),
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
  List<Map<String, dynamic>> citas = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    obtenerIdUsuario();
    obtenerCitas();
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
    final user =
        await SQLHelper.obtenerUsuariosInicioSesion('correo', 'contrasena');
    final userIdTemp = user.isNotEmpty ? user[0]['id'] : null;
    setState(() {
      userId = userIdTemp;
    });
  }

  // Método para cerrar sesión
  Future<void> _logoutUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn'); // Eliminar el estado de la sesión del usuario
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()), // Redirigir a la página de inicio de sesión
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset("assets/logobarrasf.png", width: 250)),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 38),
            ListTile(
              title: Image.asset("assets/logobarrasf.png"),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Citas'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Nuevo elemento para cerrar sesión
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                // Llamar al método para cerrar la sesión del usuario
                _logoutUser(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: const Center(
                  child: Text(
                    'Citas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
              citas.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'No tienes citas todavía',
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: citas.asMap().entries.map((entry) {
                        final index = entry.key;
                        final cita = entry.value;
                        return Center(
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: obtenerServiciosPaquete(cita['id_paquete']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
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
                                          title: Text(
                                            'Cita ${cita['id']}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
                                          ),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Detalles',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                                              const SizedBox(height: 10),
                                              Text('Fecha: ${cita['fecha']}',style:const TextStyle(fontSize: 17)),
                                              Text('Hora: ${cita['hora']}',style:const TextStyle(fontSize: 17)),
                                              Text('Estado: ${cita['estado']}',style:const TextStyle(fontSize: 17)),
                                              Text('Paquete: ${cita['nombre_paquete']}',style:const TextStyle(fontSize: 17)),
                                              const Text('Servicios:',style: TextStyle(fontSize: 17,fontWeight:FontWeight.bold)),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  for (var servicio
                                                      in serviciosPaquete)
                                                    Text('- ${servicio['nombre']}',style: const TextStyle(fontSize: 17)),
                                                ],
                                              ),
                                              Text('Colaborador: ${cita['colaborador']}',style:const TextStyle(fontSize: 17)),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cerrar', style: TextStyle(color: Color.fromARGB(255, 199, 152, 70)),),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 25),
                                    padding: const EdgeInsets.all(20),
                                    width: double
                                        .infinity, // Ajuste del ancho del contenedor
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                      border: const Border(
                                        left: BorderSide(color: Color.fromARGB(255, 199, 152, 70)),
                                        top: BorderSide(color: Color.fromARGB(255, 199, 152, 70)),
                                        bottom: BorderSide(color: Color.fromARGB(255, 199, 152, 70)),
                                        right: BorderSide(color: Color.fromARGB(255, 199, 152, 70),  width: 30),
                                      )
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cita ${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          'Fecha: ${cita['fecha']}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'Hora: ${cita['hora']}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'Estado: ${cita['estado']}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
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
            MaterialPageRoute(builder: (context) => const RegistrarCitas()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 199, 152, 70),
        child: const Icon(Icons.add, color: Colors.black, size: 40,),
      ),
    );
  }
}
