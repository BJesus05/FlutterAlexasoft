// ignore_for_file: unused_field, non_constant_identifier_names, file_names, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutteralexasoft/main.dart';

const List<String> colaborador = <String>[
  'Pneumonoultramicroscopisilicovolcanoconiosis',
  'Pablo Diego Jose Francisco de Paula Juan Nepomuceno Maria de los Remedios Cipriano de la Santisima Trinidad Ruiz y Picasso',
  'Simon Jose Antonio de la Santisima Trinidad Bolivar Palacios Ponte y Blanco',
  'Pentakismyriohexakisquilioletracosiohexacontapentagonalis'
];

class RegistrarCitas extends StatelessWidget {
  const RegistrarCitas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Raleway',
          colorScheme: const ColorScheme.light()),
      debugShowCheckedModeBanner: false,
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedColaborador = '';
  final String _Detalles = '';
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = colaborador.first;

  String _descripcion = '';

  DateTime? _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Selected ${_selectedDate}")));
      });
    });
  }

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
                title: const Text('Iniciar Sesión'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Colaborador",
                                style: TextStyle(fontSize: 15),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 230,
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  elevation: 16,
                                  icon: const Icon(
                                    Icons.person_2_sharp,
                                    color: Colors.amber,
                                  ),
                                  style:
                                      const TextStyle(color: Color(0xFF73293D)),
                                  underline: Container(
                                    height: 2,
                                    color: Color(0xFF73293D),
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: colaborador
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Descripción',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w600),
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
                              onSaved: (value) {
                                setState(() {
                                  _descripcion = value.toString();
                                });
                              },
                            )),
                        /*Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Selecciona un colaborador',
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
                              filled: true,
                            ),
                            value: _selectedColaborador,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedColaborador = value.toString();
                              });
                            },
                            items: colaborador.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor selecciona un colaborador';
                              }
                              return null;
                            },
                          ),
                        ),*/
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
                                            "Cita creada correctamente",
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
                                  backgroundColor: const Color(0xFF73293D),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Crear Cita',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _selectedDate == null
                                    ? "No has seleccionado una fecha"
                                    : "Fecha seleccionada: ${_selectedDate}",
                              ),
                              ElevatedButton(
                                onPressed: _presentDatePicker,
                                child: const Text("Seleccionar fecha"),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
