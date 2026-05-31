import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const String appEmptyLottieAssetPath = 'assets/lottie_json/cat_nothing.json';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.animationSize = 1000,
    this.textColor,
    this.spacing = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final String message;
  final double animationSize;
  final Color? textColor;
  final double spacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final text = message.trim();

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: animationSize,
                height: animationSize,
                child: Lottie.asset(
                  appEmptyLottieAssetPath,
                  repeat: true,
                ),
              ),
            ),
          ),
          if (text.isNotEmpty) ...[
            SizedBox(height: spacing),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.black54,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
