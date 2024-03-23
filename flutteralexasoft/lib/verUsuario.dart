import 'package:flutter/material.dart';
import 'package:flutteralexasoft/sqlhelper.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({Key? key}) : super(key: key);

  @override
  _RegistroViewState createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  List<Map<String, dynamic>> registros = [];

  @override
  void initState() {
    super.initState();
    obtenerRegistros();
  }

  Future<void> obtenerRegistros() async {
    final List<Map<String, dynamic>> listaRegistros =
        await SQLHelper.obtenerLibros();
    setState(() {
      registros = listaRegistros;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Registros'),
      ),
      body: ListView.builder(
        itemCount: registros.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            child: ListTile(
              title: Text('Nombre: ${registros[index]['nombre']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Correo: ${registros[index]['correo']}'),
                  Text('Instagram: ${registros[index]['instagram']}'),
                  Text('Teléfono: ${registros[index]['telefono']}'),
                  Text('Contraseña: ${registros[index]['contrasena']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
