import 'dart:io';

import 'package:attendance_app/constant/colors.dart';
import 'package:attendance_app/widgets/qr_overlay.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrscanScreen extends StatefulWidget {
  const QrscanScreen({Key? key}) : super(key: key);

  @override
  State<QrscanScreen> createState() => _QrscanScreenState();
}

class _QrscanScreenState extends State<QrscanScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;



  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble( )async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();

    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child:  buildQrView(context),
          )
         ,
          Positioned(bottom: 10, child: buildResult(),),
          QRScannerOverlay(overlayColour: bgColor),

        ],
      ),
    );
  }

  buildQrView(BuildContext context) => QRView(key: qrKey, onQRViewCreated: onQRViewCreated,overlay: QrScannerOverlayShape(
    cutOutSize: MediaQuery.of(context).size.width * 0.8,
    borderWidth: 10,
    borderLength: 20,
    borderRadius: 10,
    borderColor: primaryColor,
  ),);

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) => setState(() => this.barcode = barcode) );
  }

  buildResult() => Container(
    padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: Text(barcode != null ? 'Result : ${barcode!.code}' :'Scan a Code!', maxLines: 3,)) ;
}
