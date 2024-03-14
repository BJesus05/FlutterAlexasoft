import 'package:flutter/material.dart';
import 'package:flutteralexasoft/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  [
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
              title: Text('Inicio'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Iniciar Sesión'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Registrarse'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Registrar(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email text field
            const TextField(
              decoration: InputDecoration(
                labelText: 'Correo',
              ),
            ),
            const SizedBox(height: 10.0),

            // Password text field
            const TextField(
              obscureText: true, // Password field hides input
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 20.0),

            // Login button
            ElevatedButton(
              onPressed: () {
                // Add your login logic here
              },
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 20.0),

            // "¿No tienes cuenta?" text
            const Text(
              "¿No tienes cuenta?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10.0),

            // "Registrarse" button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Registrar(),
                  ),
                );
              },
              child: const Text('Registrarse'),
            ),
            const SizedBox(height: 20.0),

            // Row for social media buttons (replace with actual buttons)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: TextButton(
                    onPressed: () {
                      // Add your social login logic here (e.g., Google sign-in)
                    },
                    child: const Icon(Icons.house),
                  ),
                ),
                const SizedBox(width: 20.0),
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: TextButton(
                    onPressed: () {
                      // Add your social login logic here (e.g., Facebook login)
                    },
                    child: const Icon(Icons.facebook),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
