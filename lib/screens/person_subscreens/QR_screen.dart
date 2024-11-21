import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectproducts/models/person.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final Person loggedInPerson;

  const QRScannerScreen({super.key, required this.loggedInPerson});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final PersonController personController = Get.put(PersonController());
  bool isProcessing = false; // Evitar múltiples lecturas rápidas

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;

    controller!.scannedDataStream.listen((scanData) {
      if (!isProcessing) {
        isProcessing = true;

        // Verificar el contenido del código QR
        if (scanData.code == 'VALID_QR_CODE') { // Cambia 'VALID_QR_CODE' por el valor esperado
          useTicket();
        } else {
          Get.snackbar(
            'Error',
            'El código QR no es válido.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }

        Future.delayed(const Duration(seconds: 2), () {
          isProcessing = false; // Permitir nuevas lecturas después de 2 segundos
        });
      }
    });
  }

  // Función para usar un ticket
  void useTicket() {
    if (widget.loggedInPerson.remainingDays.value > 0) {
      setState(() {
        widget.loggedInPerson.remainingDays.value -= 1; // Descontar un ticket
      });

      // Sincronizar con Firestore
      personController.syncRemainingDays(widget.loggedInPerson);

      Get.snackbar(
        'Éxito',
        'Has usado un ticket. Tickets restantes: ${widget.loggedInPerson.remainingDays.value}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'No tienes tickets restantes.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 64, 255),
                Color.fromARGB(255, 3, 168, 245),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: const Text(
                'Escanea un código QR válido para usar un ticket.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
