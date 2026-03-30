import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

IconData levelStatSymbolForCount(int count) {
  if (count >= 3) return Symbols.stat_3_rounded;
  if (count == 2) return Symbols.stat_2_rounded;
  return Symbols.stat_1_rounded;
}

class LevelStatIcon extends StatelessWidget {
  const LevelStatIcon({
    super.key,
    required this.count,
    required this.color,
    required this.size,
  });

  final int count;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      levelStatSymbolForCount(count),
      size: size,
      color: color,
      weight: 700,
      grade: 200,
      opticalSize: 20,
    );
  }
}
