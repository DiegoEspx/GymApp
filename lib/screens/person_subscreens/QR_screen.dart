import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';
import 'package:proyectproducts/models/person.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';

class QRScannerScreen extends StatefulWidget {
  final Person loggedInPerson;

  const QRScannerScreen({super.key, required this.loggedInPerson});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController qrController) {
  controller = qrController;

  controller!.scannedDataStream.listen((scanData) async {
    if (!isProcessing) {
      isProcessing = true;

      // Busca el QR en Firestore
      final query = await FirebaseFirestore.instance
          .collection('qr_codes')
          .where('qrData', isEqualTo: scanData.code)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;

        if (doc['isUsed'] == false) {
          // Marca como usado
          doc.reference.update({'isUsed': true});
          useTicket();
        } else {
          Get.snackbar(
            'Error',
            'El código QR ya fue usado.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
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
        isProcessing = false;
      });
    }
  });
}


  void useTicket() {
    if (widget.loggedInPerson.remainingDays.value > 0) {
      setState(() {
        widget.loggedInPerson.remainingDays.value -= 1;
      });

      // Sincronizar con Firestore
      PersonController personController = Get.find();
      personController.syncRemainingDays(widget.loggedInPerson);

      Get.snackbar(
        'Éxito',
        'Has usado un ticket. Tickets restantes: ${widget.loggedInPerson.remainingDays.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
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
            child: const Center(
              child: Text(
                'Escanea un código QR válido.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
