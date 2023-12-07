import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:melakago/Model/quizQuestion.dart';

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

  void _checkQrId() async{
    int questionId=0;
    String questionText='';
    String answerOption1='';
    String answerOption2='';
    String answerOption3='';
    String answerOption4='';
    String correctAnswer='';
    int point=0;
    int qrId=0;

    quizQuestion question = quizQuestion (questionId, questionText, answerOption1, answerOption2, answerOption3,
        answerOption4,correctAnswer, point, qrId);

    if (barcodeScanRes.isNotEmpty) {
      // Fetch data using the scanned QR code
      bool success = await question.fetchDataUsingQrCode(barcodeScanRes);

      if (success) {
        // Access the properties of the quizQuestion instance
        print('Question ID: ${question.questionId}');
        print('Question Text: ${question.questionText}');
        print('Answer Option 1: ${question.answerOption1}');
        print('Answer Option 2: ${question.answerOption2}');
        print('Answer Option 3: ${question.answerOption3}');
        print('Answer Option 4: ${question.answerOption4}');
        print('Correct Answer: ${question.correctAnswer}');
        print('Point: ${question.point}');
        print('QR ID: ${question.qrId}');
      } else {
        print('Failed to fetch data using QR code');
      }
    } else {
      print("Please Scan a QR Code");
    }


  }

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
