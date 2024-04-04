// ignore_for_file: unused_field, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citas.dart';
import 'package:flutteralexasoft/main.dart';
import 'package:flutteralexasoft/sqlhelper.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';

bool _showPassword = false;

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
  final int? userId;

  const RegisterPage({super.key, this.userId});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  int _telefono = 0;
  String _correo = '';
  String _instagram = '';
  String _nombre = '';
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  String _verificationCode = ""; // Almacena el código de verificación generado


Future<void> _addLibro() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final bool correoExistente = await SQLHelper.verificarCorreoExistente(_correo);
    if (correoExistente) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de registro'),
            content: Text('El correo electrónico ya está registrado.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    _verificationCode = generateVerificationCode();

    await sendEmail(_verificationCode);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese el código de verificación'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _verificationCode = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await verifyVerificationCode();
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> verifyVerificationCode() async {
  if (_verificationCode == _verificationCode) {
    _formKey.currentState!.save();
    await SQLHelper.CrearUsuario(
      _nombre,
      _correo,
      _instagram,
      _telefono.toString(),
      _password,
    );
    print('Registro creado exitosamente');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  } else {
    print('Código de verificación incorrecto');
  }
}

Future<void> sendEmail(String verificationCode) async {
  const String sendGridApiKey = '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'; // Reemplaza con tu propia API Key de SendGrid
  final String verificationCode = generateVerificationCode();

//====================================NO ELIMINAR POR NADA DEL MUNDO======================================
  final smtpServer = SmtpServer(
    'smtp.sendgrid.net',
    username: 'apikey',
    password: sendGridApiKey,
    port: 587, // Puerto para TLS connections
    // Enable or disable security based on your needs
    // Enable for SSL connections (port 465) or TLS connections (ports 25 or 587)
    // ssl: true,
    // ignoreBadCertificate: true, // Esto es opcional, para ignorar certificados no válidos (¡cuidado en producción!)
  );
  //======================================================================================================

  final message = Message()
    ..from = Address('teamalexasoft@gmail.com', 'Equipo AlexaSoft')
    ..recipients.add(_correo)
    ..subject = 'Verificación de correo'
    ..text = 'Tu código de verificación es: $verificationCode';

  try {
    final sendReport = await send(message, smtpServer);
    print('Correo electrónico enviado exitosamente: $sendReport');
  } catch (e) {
    print('Error al enviar el correo electrónico: $e');
  }
}


String generateVerificationCode() {

  const int codigo = 4;
  final Random random = Random();
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < codigo; i++) {
    buffer.write(random.nextInt(10));
  }

  return buffer.toString();
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
                                hintText: 'Nombre completo*',
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
                                hintText: 'Correo*',
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
                            onSaved: (value) {
                              setState(() {
                                _correo = value
                                    .toString(); // Guarda el valor en la variable _correo
                              });
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
                                hintText: 'Teléfono*',
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
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              obscureText: !_showPassword,
                              onChanged: (value) {
                                setState(() {
                                  _password = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Contraseña*',
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
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          obscureText: !_showPassword,
                          decoration: const InputDecoration(
                            hintText: 'Confirmar contraseña*',
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value != _password) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _addLibro();
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
                        'Inicia sesión',
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
