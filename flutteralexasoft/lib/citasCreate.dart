// ignore_for_file: unused_field, non_constant_identifier_names, file_names, prefer_final_fields, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citas.dart';
import 'package:flutteralexasoft/main.dart';
import 'package:flutteralexasoft/sqlhelper.dart';

class RegistrarCitas extends StatelessWidget {
  final int? userId;

  const RegistrarCitas({super.key, this.userId});

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
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  int? get userId => null;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedColaborador = '';
  final String _Detalles = '';
  final _formKey = GlobalKey<FormState>();
  String _descripcion = '';
  DateTime? _selectedDate;
  DateTime? _selectedDateTime;

  Future<void> _presentDateTimePicker() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Restringe las fechas anteriores al día actual
      lastDate:
          DateTime(now.year + 1), // Permite fechas hasta 1 año en el futuro
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Selected $_selectedDate")));
      });
    });
  }

  List<Map<String, dynamic>> _colaboradores = [];
  List<Map<String, dynamic>> _paquetes = [];
  @override
  void initState() {
    super.initState();
    obtenerColaboradores();
  }

 Future<void> obtenerColaboradores() async {
    final colaboradores = await SQLHelper.obtenerColaboradores();
    setState(() {
      _colaboradores = colaboradores; 
    });
  }
  void _refreshJournals() async {
    final colaboradores = await SQLHelper.obtenerColaboradores();
    final paquetes = await SQLHelper.obtenerPaquetes();
    setState(() {
      _colaboradores = colaboradores;
      _paquetes = paquetes;
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
                                  child: DropdownButtonFormField<int>( // Cambio a tipo int para el ID del colaborador
                              isExpanded: true,
                              decoration: InputDecoration(
                                hintText: 'Colaborador',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(Icons.person),
                                fillColor: Color.fromARGB(255, 89, 89, 89),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              items: _colaboradores.map<DropdownMenuItem<int>>((colaborador) { // Mapeo usando _colaboradores
                                return DropdownMenuItem<int>(
                                  value: colaborador['id'], // Asigna el ID del colaborador como valor
                                  child: Text(colaborador['nombre']), // Muestra el nombre del colaborador
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor selecciona el nombre del colaborador';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _selectedColaborador = value!.toString(); // Asigna el valor seleccionado a _selectedColaborador
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  _selectedColaborador = value!.toString(); // Asigna el valor seleccionado a _selectedColaborador
                                });
                              },
),),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Descripción',
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _selectedDateTime == null
                                    ? 'No has seleccionado fecha y hora'
                                    : 'Fecha y Hora seleccionadas: ${_selectedDateTime.toString()}',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: _presentDateTimePicker,
                                child: Text(
                                  'Seleccionar Fecha y Hora',
                                  style: TextStyle(
                                      color: Color.fromRGBO(238, 211, 59, 1)),
                                ),
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
                                    await SQLHelper.guardarCita(
                                        _descripcion,
                                        _selectedDate,
                                        _selectedColaborador,
                                        widget.userId);

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
                                  backgroundColor:
                                      const Color.fromARGB(255, 27, 29, 29),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Crear Cita',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
