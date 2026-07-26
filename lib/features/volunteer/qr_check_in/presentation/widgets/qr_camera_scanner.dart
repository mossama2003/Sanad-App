import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sanad_app/features/volunteer/qr_check_in/presentation/widgets/scanner_overlay_widget.dart';

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
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

          const IgnorePointer(child: ScannerOverlayWidget()),
        ],
      ),
    );
  }
}
