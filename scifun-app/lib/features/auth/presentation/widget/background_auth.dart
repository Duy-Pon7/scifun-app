import 'package:flutter/material.dart';
import 'package:thilop10_3004/core/utils/assets/app_image.dart';

class BackgroundAuth extends StatelessWidget {
  const BackgroundAuth({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFFFF0F0),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              AppImage.itemAuth,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
