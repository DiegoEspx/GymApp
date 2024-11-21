import 'package:flutter/material.dart';

class GenerateQRScreen extends StatelessWidget {
  final String qrData; // Contenido dinámico del QR

  const GenerateQRScreen({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    final qrUrl =
        'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$qrData';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Código QR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Código QR Generado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.network(qrUrl),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
