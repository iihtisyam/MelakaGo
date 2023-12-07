import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(MaterialApp(
    home: const qrscanner(),
  ));
}

class qrscanner extends StatefulWidget {
  const qrscanner({Key? key}) : super(key: key);

  @override
  State<qrscanner> createState() => _qrscannerState();
}

class _qrscannerState extends State<qrscanner> {
  String barcodeScanRes = '';

  Future<void> ScanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      // Use barcodeScanRes directly instead of _scanBarcodeResult
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
                  onPressed: ScanBarcodeNormal,
                  child: const Text('Scan Your QR'),
                ),
                SizedBox(height: 20),
                Text(
                  'Scanned Result: $barcodeScanRes',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ));
  }
}
