// ignore_for_file: unused_field, avoid_unnecessary_containers, library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citas.dart';
import 'package:flutteralexasoft/register.dart';
import 'package:flutteralexasoft/sqlhelper.dart';
import 'package:flutteralexasoft/verUsuario.dart';

//----ESTO ES PARA VER LA CONTRASEÑA----
bool _showPassword = false;
//--------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome(); // Inicia la navegación al home después de un tiempo
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/iniciosf.png'), // Ajusta esta imagen según tu logo o diseño
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String contrasena = '';
  TextEditingController correoController = TextEditingController(); // Controlador para el campo de correo


Future<void> _loginUser() async {
  String correo = correoController.text;
  final usuarios = await SQLHelper.obtenerLibrosInicioSesion(correo, contrasena);
  if (usuarios.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.check_circle),
          SizedBox(width: 5),
          Text(
            "Te has logueado correctamente",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          )
        ],
      ),
      duration: const Duration(milliseconds: 5000),
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      backgroundColor: const Color.fromARGB(255, 12, 195, 106),
    ));
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Citas()), // Reemplaza OtraVentana() con el widget de tu siguiente pantalla
  );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.error),
          SizedBox(width: 5),
          Text(
            "El correo o contraseña son incorrectos",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          )
        ],
      ),
      duration: const Duration(milliseconds: 5000),
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    ));
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logobarrasf.png", width: 250),
      ),
      endDrawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 38,
          ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Citas(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
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
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('RegisterView'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistroView(),
                ),
              );
            },
          ),
        ],
      )),
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
                      controller: correoController,
                      decoration: const InputDecoration(
                        hintText: 'Correo',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                        fillColor: Color.fromARGB(255, 89, 89, 89),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                      ),
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
                    ),
                  ),
                  Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              obscureText: !_showPassword,
                              onChanged: (value) {
                                setState(() {
                                  contrasena = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Contraseña',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                              ),
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
                            ),
                            IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                    await _loginUser();
                                  }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 27, 29, 29),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Login')),
                        )),
                  ],
                )),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the content horizontally
              children: [
                const Text(
                  "¿No tienes cuenta?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Registrar()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 27, 29, 29),
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
