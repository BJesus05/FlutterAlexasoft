import "package:flutter/material.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = "Resgistro";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body:
        const MyStatefulWidget(),
      ),
    );
  }
}

enum SingingCharacter { f, otro, m }

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? value;
  SingingCharacter? _character = SingingCharacter.otro;
  String _contrasena = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              decoration: const InputDecoration(
                hintText: "Nombre",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu nombre";
                }
                return null;
              }),
          TextFormField(
              decoration: const InputDecoration(
                hintText: "Apellidos",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tus apellidos";
                }
                return null;
              }),
          
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio<SingingCharacter>(
                        value: SingingCharacter.f,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      const Text('Femenino')
                    ],
                  ),
                  Row(
                    children: [
                      Radio<SingingCharacter>(
                        value: SingingCharacter.m,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      const Text('Masculino')
                    ],
                  ),
                  Row(
                    children: [
                      Radio<SingingCharacter>(
                        value: SingingCharacter.otro,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      const Text('Otro')
                    ],
                  ),
                ],
              )),
          TextFormField(
              decoration: const InputDecoration(
                hintText: "Email",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu email";
                } else if (!value.contains("@")) {
                  return "El email debe contener un @";
                } else if (!value.endsWith("gmail.com") &&
                    !value.endsWith("hotmail.com") &&
                    !value.endsWith("yahoo.com")) {
                  return "El email debe ser de gmail.com, hotmail.com o yahoo.com";
                }
                return null;
              }),
          TextFormField(
              decoration: const InputDecoration(
                hintText: "Contraseña",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu contraseña";
                } else if (value.contains(RegExp(r"[@#$%^&*()!+=-]"))) {
                  return "La contraseña no puede contener caracteres especiales";
                } else if (value.length < 10) {
                  return "La contraseña debe ser de al menos 10 caracteres";
                } else if (value.length >= 20) {
                  return "La contraseña debe tener 20 o menos caracteres";
                }
                _contrasena = value;
                return null;
              }),
          TextFormField(
              decoration: const InputDecoration(
                hintText: "Confirmar Contraseña",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu contraseña";
                } else if (value != _contrasena) {
                  return "Las contraseñas no coinciden";
                }
                return null;
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Datos Correctos"))
                    );
                  }else{
                    
                  }
                },
                child: const Text("Enviar")),
          ),
        ],
      ),
    );
  }
}
