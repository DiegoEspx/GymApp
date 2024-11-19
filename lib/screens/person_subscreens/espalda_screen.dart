import 'package:flutter/material.dart';

class EspaldaScreen extends StatelessWidget {
  const EspaldaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutina de Espalda'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ejercicios para Espalda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('- Dominadas'),
            Text('- Remo con barra'),
            Text('- Jalón al pecho'),
            Text('- Peso muerto'),
          ],
        ),
      ),
    );
  }
}
