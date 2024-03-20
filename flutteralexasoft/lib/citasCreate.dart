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
                              
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Colaborador',
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            prefixIcon: const Icon(Icons.person),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          items: colaborador
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(overflow: TextOverflow.ellipsis), maxLines: 2),

                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor seleccione el nombre del empleado';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Actualiza el valor seleccionado del empleado 
                          },
                          onSaved: (value) {
                            // Guarda el valor seleccionado del empleado 
                          },
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
