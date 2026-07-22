import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCameraScanner extends StatefulWidget {
  const QrCameraScanner({super.key, required this.onDetect});

  final Function(String code) onDetect;

  @override
  State<QrCameraScanner> createState() => _QrCameraScannerState();
}

class _QrCameraScannerState extends State<QrCameraScanner> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),

      child: MobileScanner(
        fit: BoxFit.cover,

        onDetect: (capture) {
          if (scanned) return;

          final barcode = capture.barcodes.firstOrNull;

          final value = barcode?.rawValue;

          if (value != null) {
            scanned = true;

            widget.onDetect(value);
          }
        },
      ),
    );
  }
}
