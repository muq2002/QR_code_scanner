import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(title: Text('Home Screen')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: startScanner,
                child: Text('Scan QR Code'),
              ),
            ),
          ),
          Expanded(
            flex: scannerActive ? 5 : 0,
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
              child: Text('Barcode Type: ${result!.format}\nData: ${result!.code}'),
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
        // Forward the scanned URL to UrlScreen
        Navigator.pushNamed(context, '/url', arguments: result!.code);
      }
    });
  }

  void startScanner() {
    setState(() {
      scannerActive = true;
    });
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
