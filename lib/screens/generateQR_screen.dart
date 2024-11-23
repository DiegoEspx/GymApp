import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class GenerateQRScreen extends StatelessWidget {
  final String userId;

  GenerateQRScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final qrData = Uuid().v4(); // Genera un identificador único

    // Guardar QR en Firestore
    FirebaseFirestore.instance.collection('qr_codes').doc(userId).set({
      'qrData': qrData,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'isUsed': false, // Indica que aún no se ha utilizado
    });

    final qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$qrData';

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
