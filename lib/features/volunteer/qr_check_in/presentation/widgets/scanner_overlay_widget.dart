import 'package:flutter/material.dart';

import '../../../../../core/style/app_colors.dart';

class ScannerOverlayWidget extends StatefulWidget {
  const ScannerOverlayWidget({super.key});

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  static const double scanSize = 250.0;
  static const double cornerLength = 32.0;
  static const double cornerThickness = 5.0;
  static const double boxRadius = 24.0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _ScannerMaskPainter(
                scanSize: scanSize,
                boxRadius: boxRadius,
              ),
            ),

            Center(
              child: SizedBox(
                width: scanSize,
                height: scanSize,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(boxRadius),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .25),
                          width: 1,
                        ),
                      ),
                    ),

                    Positioned(
                      top: -1,
                      left: -1,
                      child: _Corner(
                        top: true,
                        left: true,
                        length: cornerLength,
                        thickness: cornerThickness,
                      ),
                    ),

                    Positioned(
                      top: -1,
                      right: -1,
                      child: _Corner(
                        top: true,
                        left: false,
                        length: cornerLength,
                        thickness: cornerThickness,
                      ),
                    ),

                    Positioned(
                      bottom: -1,
                      left: -1,
                      child: _Corner(
                        top: false,
                        left: true,
                        length: cornerLength,
                        thickness: cornerThickness,
                      ),
                    ),

                    Positioned(
                      bottom: -1,
                      right: -1,
                      child: _Corner(
                        top: false,
                        left: false,
                        length: cornerLength,
                        thickness: cornerThickness,
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(boxRadius),
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: controller,
                            builder: (_, _) {
                              return Positioned(
                                top: controller.value * (scanSize - 3),
                                left: 8,
                                right: 8,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.greenAccent,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.greenAccent.withValues(
                                          alpha: .8,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScannerMaskPainter extends CustomPainter {
  _ScannerMaskPainter({required this.scanSize, required this.boxRadius});

  final double scanSize;
  final double boxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final maskPaint = Paint()..color = Colors.black.withValues(alpha: .55);

    final fullRect = Offset.zero & size;

    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanSize,
      height: scanSize,
    );

    final scanRRect = RRect.fromRectAndRadius(
      scanRect,
      Radius.circular(boxRadius),
    );

    final path = Path()
      ..addRect(fullRect)
      ..addRRect(scanRRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, maskPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerMaskPainter oldDelegate) => false;
}

class _Corner extends StatelessWidget {
  const _Corner({
    required this.top,
    required this.left,
    required this.length,
    required this.thickness,
  });

  final bool top;
  final bool left;
  final double length;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: length,
      height: length,
      child: CustomPaint(
        painter: _CornerPainter(top: top, left: left, thickness: thickness),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({
    required this.top,
    required this.left,
    required this.thickness,
  });

  final bool top;
  final bool left;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        colors: const [AppColors.primary, Colors.greenAccent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final horizontalY = top ? thickness / 2 : size.height - thickness / 2;
    final verticalX = left ? thickness / 2 : size.width - thickness / 2;

    final horizontalPath = Path();

    if (left) {
      horizontalPath
        ..moveTo(0, horizontalY)
        ..lineTo(size.width * .6, horizontalY);
    } else {
      horizontalPath
        ..moveTo(size.width, horizontalY)
        ..lineTo(size.width - size.width * .6, horizontalY);
    }

    canvas.drawPath(horizontalPath, paint);

    final verticalPath = Path();

    if (top) {
      verticalPath
        ..moveTo(verticalX, 0)
        ..lineTo(verticalX, size.height * .6);
    } else {
      verticalPath
        ..moveTo(verticalX, size.height)
        ..lineTo(verticalX, size.height - size.height * .6);
    }

    canvas.drawPath(verticalPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => false;
}
