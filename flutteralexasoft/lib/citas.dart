import 'package:flutter/material.dart';

class Citas extends StatelessWidget {
  const Citas({super.key});

  // This widget is the root of your application.
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
  const CitasPage({Key? key}) : super(key: key);

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
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
            ]),
      )),
      /*floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AgregarCita()),
        );
      },
      child: const Icon(Icons.add),
      backgroundColor: const Color(0xFF73293D),
    ),*/
    );
  }
}
