import 'package:flutter/material.dart';

class BrazoScreen extends StatelessWidget {
  const BrazoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutina de Brazo'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ejercicios para Brazo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('- Curl de bíceps con barra'),
            Text('- Curl martillo'),
            Text('- Extensiones de tríceps con polea'),
            Text('- Fondos para tríceps'),
          ],
        ),
      ),
    );
  }
}
