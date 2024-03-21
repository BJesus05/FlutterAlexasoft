import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citasCreate.dart';


class Citas extends StatelessWidget {
  const Citas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citas',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Raleway',
          colorScheme: const ColorScheme.light()),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Luxury by Experts", style: TextStyle(fontStyle: FontStyle.italic),) //Image.asset("assets/logosf.png", width: 125),
      ),
      endDrawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Image.asset("assets/logosf.png"),
          ),
          
          ListTile(
            leading: const Icon(Icons.schedule, color: Color(0xFF73293D)),
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
        margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
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
        backgroundColor: const Color(0xFF73293D),
        child: const Icon(Icons.add),
      ),
    );
  }
}
