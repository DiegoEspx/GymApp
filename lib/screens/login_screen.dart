import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/screens/home_screen.dart';
import 'package:proyectproducts/screens/person_screen.dart'; // Importamos PersonScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = GetStorage();

  // Método para simular el login
  void _login() {
    // Aquí deberías agregar la lógica de autenticación con Firebase o cualquier backend que estés usando
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Para este ejemplo, vamos a usar datos simulados
    if (username == 'admin' && password == 'admin123') {
      // Simulamos que el rol es 'admin'
      storage.write('role', 'admin');
      // Redirigimos a la pantalla de admin
      Get.off(() => HomeScreen());
    } else if (username == 'persona' && password == 'persona123') {
      // Simulamos que el rol es 'persona'
      storage.write('role', 'persona');
      // Redirigimos a la pantalla de persona
      Get.off(() => PersonScreen());
    } else {
      // Si las credenciales no son correctas, mostramos un mensaje de error
      Get.snackbar('Error', 'Credenciales incorrectas',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _login();
                  }
                },
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
