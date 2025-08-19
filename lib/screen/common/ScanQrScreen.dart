import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';



class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {

  MobileScannerController controller=MobileScannerController();
  bool hasPopped = false;

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Scan Qr',
          style: TextStyle(color: Colors.white, fontFamily: 'PoppinsR'),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: MediaQuery.sizeOf(contexto).width,
              height: MediaQuery.sizeOf(contexto).height * 0.6,
              child: MobileScanner(
                controller: controller,
                onDetect: (result) {
                  if (hasPopped) return;
                  hasPopped = true;

                  String resp = result.barcodes.first.rawValue ?? '';
                  Navigator.of(contexto).pop(resp);
                },
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              controller.toggleTorch();
            },
            icon: Icon(Icons.flashlight_on_sharp),
          ),
        ],
      ),
    );
  }
}