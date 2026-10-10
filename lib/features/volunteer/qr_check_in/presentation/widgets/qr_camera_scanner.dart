import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sanad_app/features/volunteer/qr_check_in/presentation/widgets/scanner_overlay_widget.dart';

class QrCameraScanner extends StatelessWidget {
  const QrCameraScanner({
    super.key,
    required this.controller,
    required this.onDetect,
    required this.active,
  });

  final MobileScannerController controller;
  final Function(String code) onDetect;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              if (!active) return;
              final barcode = capture.barcodes.firstOrNull;
              final value = barcode?.rawValue;
              if (value != null) onDetect(value);
            },
          ),

          IgnorePointer(child: ScannerOverlayWidget(active: active)),
        ],
      ),
    );
  }
}
