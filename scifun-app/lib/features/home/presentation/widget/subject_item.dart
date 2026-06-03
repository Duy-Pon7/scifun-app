import 'package:flutter/material.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';

class SubjectItem extends StatelessWidget {
  static const double _baseCardWidth = 125;
  static const double _baseCardHeight = 150;
  static const double _baseAvatarSize = 100;
  static const double _baseCardTopInset = 34;
  static const double _baseCardRadius = 10;

  const SubjectItem({
    super.key,
    required this.subjectName,
    required this.imagePath,
    required this.onTap,
    this.isSelected = false,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedTextColor,
    this.cardWidth,
  });

  final String subjectName;
  final String imagePath;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;
  final double? cardWidth;

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isSelected ? (selectedBackgroundColor ?? Colors.white) : Colors.white;
    final borderColor = isSelected
        ? (selectedBorderColor ?? Colors.transparent)
        : Colors.transparent;
    final textColor =
        isSelected ? (selectedTextColor ?? Colors.black87) : Colors.black;

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedWidth = _resolveWidth(constraints);
        final resolvedHeight = _resolveHeight(
          constraints: constraints,
          resolvedWidth: resolvedWidth,
        );

        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: resolvedWidth,
            height: resolvedHeight,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: _baseCardWidth,
                height: _baseCardHeight,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.only(top: _baseCardTopInset),
                      width: _baseCardWidth,
                      height: _baseCardHeight - _baseCardTopInset,
                      padding: const EdgeInsets.fromLTRB(10, 70, 10, 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(_baseCardRadius),
                        border: Border.all(
                          color: isSelected
                              ? borderColor.withValues(alpha: 0.35)
                              : Colors.transparent,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? borderColor.withValues(alpha: 0.20)
                                : Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 0.5,
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          subjectName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: _baseAvatarSize,
                      height: _baseAvatarSize,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cardColor.withValues(alpha: 0.65)
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? borderColor.withValues(alpha: 0.30)
                              : Colors.white,
                          width: isSelected ? 1.2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_baseAvatarSize),
                        child: CustomNetworkAssetImage(
                          imagePath: imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _resolveWidth(BoxConstraints constraints) {
    if (cardWidth != null && cardWidth!.isFinite && cardWidth! > 0) {
      if (constraints.hasBoundedWidth) {
        return cardWidth!.clamp(0.0, constraints.maxWidth).toDouble();
      }
      return cardWidth!;
    }

    if (constraints.hasBoundedWidth && constraints.maxWidth > 0) {
      return constraints.maxWidth;
    }

    return _baseCardWidth;
  }

  double _resolveHeight({
    required BoxConstraints constraints,
    required double resolvedWidth,
  }) {
    if (constraints.hasBoundedHeight && constraints.maxHeight > 0) {
      return constraints.maxHeight;
    }

    return _baseCardHeight * (resolvedWidth / _baseCardWidth);
  }
}
