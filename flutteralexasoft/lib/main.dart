// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutteralexasoft/register.dart';
import 'package:flutteralexasoft/citasCreate.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Raleway',
          colorScheme: const ColorScheme.light()),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

enum SinginCharacter { femenino, masculino }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF73293D),
              ),
              child: Text(
                'Alexandra Torres',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 37,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF73293D)),
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
              leading: const Icon(Icons.schedule, color: Color(0xFF73293D)),
              title: const Text('Citas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrarCitas(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration, color: Color(0xFF73293D)),
              title: const Text('Registrarse'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Registrar(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('¡Ya puedes loguearte, bienvenido!'),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Correo',
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              fillColor: Colors.grey.shade200,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                              filled: true),
                          validator: (value) {
                            String pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = RegExp(pattern);
                            if (value!.isEmpty) {
                              return "El correo es necesario";
                            } else if (!regExp.hasMatch(value)) {
                              return "Correo invalido";
                            } else {
                              return null;
                            }
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: 'Contraseña',
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              fillColor: Colors.grey.shade200,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                              filled: true),
                          validator: (value) {
                            String pattern =
                                r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$';
                            RegExp regExp = RegExp(pattern);
                            if (value!.isEmpty) {
                              return "La contraseña es necesaria";
                            } else if (!regExp.hasMatch(value)) {
                              return "La contraseña debe tener al menos 8 caracteres, 1 letra mayúscula, 1 minúscula y 1 número. Además puede contener caracteres especiales.";
                            } else {
                              return null;
                            }
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.check_circle,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Te haz logueado correctamente. Bienvenido!",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        )
                                      ],
                                    ),
                                    duration:
                                        const Duration(milliseconds: 5000),
                                    width: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 12, 195, 106),
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF73293D),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Login')),
                        )),
                  ],
                )),
            const Text(
              "¿No tienes cuenta?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Registrar(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73293D)),
              child: const Text(
                'Registrarse',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(158, 115, 41, 61),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© CopyRight 2024 - AlexaSoft',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
