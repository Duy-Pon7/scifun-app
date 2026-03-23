import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const String appLoadingLottieAssetPath =
    'assets/lottie_json/cat_paw_loading.json';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 80,
    this.message = 'Đang tải...',
    this.lottieAssetPath = appLoadingLottieAssetPath,
  });

  final double size;
  final String message;
  final String lottieAssetPath;

  @override
  Widget build(BuildContext context) {
    final text = message.trim();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Lottie.asset(
            lottieAssetPath,
            repeat: true,
            fit: BoxFit.contain,
          ),
        ),
        if (text.isNotEmpty) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size * 2.2),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
