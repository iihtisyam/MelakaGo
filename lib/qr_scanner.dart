import 'package:flutter/material.dart';
//import 'dart:html';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:melakago/quizpage.dart';

void main() {
  runApp(MaterialApp(
    home: const QrScanner(),
  ));
}

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String barcodeScanRes = '';

  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(barcodeScanRes);

      int qrCode = int.tryParse(barcodeScanRes) ?? 0;

      // Pass the result to another class
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => quizPage(qrCode: qrCode),
        ),
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      barcodeScanRes = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Center(
          child: const Text(
            'Scan Your Questions Here',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ),
        backgroundColor: Colors.lightGreen.shade700,
      ),
      body: Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: scanBarcodeNormal,
                child: const Text('Scan Your QR'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}