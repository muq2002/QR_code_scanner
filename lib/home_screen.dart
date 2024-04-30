import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool scannerActive = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: startScanner,
                child: Text('Scan QR Code'
                , style: TextStyle(
                    color: Colors.white
                  ),),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  primary: Colors.blueAccent,
                ),
              ),
            ),
          ),
          Expanded(
            flex: scannerActive ? 6 : 0,
            child: scannerActive
                ? QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            )
                : Container(),
          ),
          if (result != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Barcode Type: ${result!.format}\nData: ${result!.code}',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        setState(() {
          scannerActive = false;
          // // End the scanner immediately
          controller?.pauseCamera();
        });

        Navigator.pushNamed(context, '/patient', arguments: result!.code);

      }
    });
  }

  void startScanner() {
    setState(() {
      scannerActive = true;
      // Start the scanner immediately
      controller?.resumeCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
