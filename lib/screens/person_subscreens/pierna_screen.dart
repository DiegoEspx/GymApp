import 'package:flutter/material.dart';

class PiernaScreen extends StatelessWidget {
  const PiernaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutina de Pierna'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ejercicios para Pierna:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('- Sentadillas'),
            Text('- Prensa de piernas'),
            Text('- Zancadas'),
            Text('- Peso muerto rumano'),
          ],
        ),
      ),
    );
  }
}
