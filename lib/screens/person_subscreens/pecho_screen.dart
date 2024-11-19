import 'package:flutter/material.dart';

class PechoScreen extends StatelessWidget {
  const PechoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutina de Pecho'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ejercicios para Pecho:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('- Press de banca'),
            Text('- Aperturas con mancuernas'),
            Text('- Fondos en paralelas'),
            Text('- Flexiones de pecho'),
          ],
        ),
      ),
    );
  }
}
