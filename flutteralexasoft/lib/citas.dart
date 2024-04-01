import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citasCreate.dart';
import 'package:flutteralexasoft/main.dart';
import 'package:flutteralexasoft/sqlhelper.dart';

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
  int?
      userId; // Variable para almacenar el ID del usuario que ha iniciado sesión

  @override
  void initState() {
    super.initState();
    obtenerIdUsuario(); // Obtener el ID del usuario al cargar la vista
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
          /*ListTile(
            leading: const Icon(Icons.home, color: Color(0xFF73293D)),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CerrarSesion(),
                ),
              );
            },
          ),*/
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
                  'Citas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No tienes citas todavia',
                    ),
                  ],
                ),
              ),
            ]),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrarCitas()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 27, 29, 29),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
