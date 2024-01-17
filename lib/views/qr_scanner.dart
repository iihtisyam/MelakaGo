import 'package:flutter/material.dart';
//import 'dart:html';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:melakago/Model/appUser.dart';
import 'package:melakago/views/quizpage.dart';
import 'package:melakago/views/home_view.dart';
import 'package:melakago/views/rewardpage.dart';
import 'package:melakago/views/editProfile.dart';

/*void main() {
  runApp(MaterialApp(
    home: QrScanner({required this.user}),
  ));
}*/

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key, required this.user}) : super(key: key); //yang ni amik data user

  final appUser user;

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

      int qrCode = int.parse(barcodeScanRes);

      // Pass the result to another class
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => quizPage(qrCode: qrCode, user: widget.user,),
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
        //toolbarHeight: 90,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Scan Your Questions Here',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white,),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: scanBarcodeNormal,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  'Scan QR',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            // Set showSelectedLabels and showUnselectedLabels to false
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),// Adjust the vertical padding as needed
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, color: Colors.black),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code, color: Colors.black),
                label: 'QrCode',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard, color: Colors.black),
                label: 'Reward',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                label: 'Account',
              ),
            ],
            onTap: (index) {
              // Handle item tap
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExplorePage(user: widget.user),
                    ),
                  );
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScanner(user: widget.user),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RewardPage(user: widget.user),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => updateProfilePage(user: widget.user),
                    ),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
