import 'package:flutter/material.dart';

class ScannerOverlayWidget extends StatefulWidget {
  const ScannerOverlayWidget({super.key});

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
        const scanSize = 250.0;

        return Center(
          child: SizedBox(
            width: scanSize,
            height: scanSize,
            child: Stack(
              children: [
                /// الزوايا
                const Positioned(
                  top: 0,
                  left: 0,
                  child: _Corner(top: true, left: true),
                ),

                const Positioned(
                  top: 0,
                  right: 0,
                  child: _Corner(top: true, left: false),
                ),

                const Positioned(
                  bottom: 0,
                  left: 0,
                  child: _Corner(top: false, left: true),
                ),

                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: _Corner(top: false, left: false),
                ),

                /// الخط الأخضر
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, _) {
                    return Positioned(
                      top: controller.value * (scanSize - 2),
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent,
                              blurRadius: 10,
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
        );
      },
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.top, required this.left});

  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          bottom: !top
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          right: !left
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}
