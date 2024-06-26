// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citas.dart';
import 'package:flutteralexasoft/register.dart';
import 'package:flutteralexasoft/sqlhelper.dart';
import 'package:flutteralexasoft/verUsuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _showPassword = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, int? userId});

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
      home: FutureBuilder<bool>(
        future:
            isUserLoggedIn(), // Método para verificar si el usuario ya ha iniciado sesión
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              if (snapshot.data == true) {
                // El usuario ya ha iniciado sesión, muestra la página de citas
                return const Citas();
              } else {
                // El usuario no ha iniciado sesión, muestra la página de inicio de sesión
                return const MyHomePage();
              }
            }
          }
        },
      ),
    );
  }

  Future<bool> isUserLoggedIn() async {
    // Aquí debes implementar la lógica para verificar si el usuario ya ha iniciado sesión
    // Por ejemplo, puedes utilizar SharedPreferences, base de datos local, etc.
    // Devuelve true si el usuario ya ha iniciado sesión, false en caso contrario
    // Este es solo un ejemplo de implementación:
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showImage = true;

  @override
  void initState() {
    super.initState();
    _loadMainPage();
  }

  void _loadMainPage() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _showImage = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _showImage
            ? Column(
                key: const Key('image'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/iniciosf.png'),
                  const SizedBox(height: 20),
                ],
              )
            : const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 238, 211, 59)),
              ),
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
  TextEditingController correoController = TextEditingController();
  bool _showProgress = false;

  Future<void> _loginUser() async {
    setState(() {
      _showProgress = true; // Mostrar el indicador de progreso
    });
    String correo = correoController.text;
    final usuarios =
        await SQLHelper.obtenerUsuariosInicioSesion(correo, contrasena);
    await Future.delayed(const Duration(seconds: 2));
    if (usuarios.isNotEmpty) {
      // El inicio de sesión es exitoso
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(
          'isLoggedIn', true); // Guardar el estado de la sesión del usuario
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
      final userId = await SQLHelper.getUserId(correo, contrasena);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Citas(userId: userId),
        ),
      );
    } else {
      // El inicio de sesión ha fallado
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
    setState(() {
      _showProgress = false;
    });
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
              Navigator.pop(context);
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
                            fontWeight: FontWeight.w600, color: Colors.white),
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
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                        child: const Text('Login'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        builder: (context) => const Registrar(),
                      ),
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
      // Mostrar el indicador de progreso si _showProgress es true
      floatingActionButton: _showProgress
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 238, 211, 59)), // Cambia el color aquí
            )
          : null,
    );
  }
}
