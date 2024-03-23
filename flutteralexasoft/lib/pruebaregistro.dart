// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citas.dart';
import 'package:flutteralexasoft/main.dart';
import 'package:flutteralexasoft/sqlhelper.dart';


class Registrar extends StatelessWidget {
  const Registrar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlexaSoft Team',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Raleway',
        colorScheme: const ColorScheme.dark(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 59, 59, 59),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  int _telefono = 0;
  String _instagram = '';
  String _nombre = '';
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmarPasswordController = TextEditingController();


  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _instagramController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  Future<void> _addLibro() async {
  
     await SQLHelper.createLibros(
     _nombreController.text,
      _correoController.text,
    _instagramController.text,
    _telefonoController.text,
    _passwordController.text,
   );
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
        ],
      )),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('¡Ya puedes registrarte, bienvenido!'),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Nombre completo',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                filled: true),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _nombre = value.toString();
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Correo',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                enabledBorder: OutlineInputBorder(
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
                            decoration: const InputDecoration(
                                hintText: 'Instagram (Opcional)',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                filled: true),
                            onSaved: (value) {
                              setState(() {
                                _instagram = value.toString();
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Teléfono',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                filled: true),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor ingrese su teléfono';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _telefono = int.parse(value.toString());
                              });
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
                            decoration: const InputDecoration(
                                hintText: 'Contraseña',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                enabledBorder: OutlineInputBorder(
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
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'Confirmar contraseña',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                filled: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (value != _password) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                onPressed: () {
                                  _addLibro();
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
                                            "Usuario registrado correctamente",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                          )
                                        ],
                                      ),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      width: 300,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 10),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 12, 195, 106),
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 27, 29, 29),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Registrarse')),
                          )),
                    ],
                  )),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the content horizontally
                children: [
                  const Text(
                    "¿Ya tienes una cuenta?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: const Text(
                        'Inicia sesisón',
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
