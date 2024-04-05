// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutteralexasoft/citas.dart';
import 'package:flutteralexasoft/main.dart';
import 'package:flutteralexasoft/sqlhelper.dart';
import 'package:intl/intl.dart';

class RegistrarCitas extends StatelessWidget {

  const RegistrarCitas({super.key, int? userId});

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

  get userId => 1;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _selectedColaborador = 0;
  int _selectedPaquete = 0;
  final _formKey = GlobalKey<FormState>();
  String _descripcion = '';
  DateTime? _selectedDateTime;
  bool _showProgress = false;

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

  List<Map<String, dynamic>> _colaboradores = [];
  List<Map<String, dynamic>> _paquetes = [];
  @override
  void initState() {
    super.initState();
    obtenerValores();
  }

  Future<void> obtenerValores() async {
    final colaboradores = await SQLHelper.obtenerColaboradores();
    final paquete = await SQLHelper.obtenerPaquetes();
    setState(() {
      _colaboradores = colaboradores;
      _paquetes = paquete;
    });
  }

  void _loadMainPage() async {
    setState(() {
      _showProgress = true; // Muestra el indicador de progreso
    });
    await Future.delayed(const Duration(seconds: 3)); // Simula la carga
    setState(() {
      _showProgress = false; // Oculta el indicador de progreso
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Citas()),
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
        ),
      ),
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
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                hintText: 'Colaborador',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                prefixIcon: const Icon(Icons.person),
                                fillColor:
                                    const Color.fromARGB(255, 89, 89, 89),
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              items: _colaboradores
                                  .map<DropdownMenuItem<int>>((colaborador) {
                                return DropdownMenuItem<int>(
                                  value: colaborador['id'],
                                  child: Text(colaborador['nombre']),
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
                                  _selectedColaborador = value!;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  _selectedColaborador =
                                      value!; // Asigna el valor seleccionado a _selectedColaborador
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              width: 300,
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  hintText: 'Paquete',
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  prefixIcon: const Icon(Icons.card_giftcard),
                                  fillColor:
                                      const Color.fromARGB(255, 89, 89, 89),
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
                                items: _paquetes
                                    .map<DropdownMenuItem<int>>((paquete) {
                                  return DropdownMenuItem<int>(
                                    value: paquete['id'],
                                    child: Text(paquete['nombre']),
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
                                    _selectedPaquete = value!;
                                  });
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _selectedPaquete = value!;
                                  });
                                },
                              ),
                            ),
                          ),
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
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            filled: true),
                        onSaved: (value) {
                          setState(() {
                            _descripcion = value.toString();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _selectedDateTime == null
                                ? 'No has seleccionado fecha y hora'
                                : 'Fecha y Hora: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _presentDateTimePicker,
                            child: const Text(
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
                              setState(() {
                                _showProgress =
                                    true; // Muestra el indicador de progreso
                              });
                              await SQLHelper.guardarCita(
                                  _descripcion,
                                  _selectedDateTime!,
                                  _selectedColaborador,
                                  widget.userId!,
                                  _selectedPaquete);
                              setState(() {
                                _showProgress = false;
                              });

                              // Redirigir a la página principal después de un tiempo
                              _loadMainPage();
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showProgress
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 238, 211, 59)), // Cambia el color aquí
            )
          : null,
    );
  }
}
