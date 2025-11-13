import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomMathWidget extends StatelessWidget {
  final String? math;
  final double displaySize;
  final double inlineSize;

  const CustomMathWidget({
    super.key,
    required this.math,
    this.displaySize = 20, // mặc định nhỏ
    this.inlineSize = 16, // mặc định nhỏ hơn nữa
  });

  @override
  Widget build(BuildContext context) {
    if (math == null || math!.isEmpty) {
      return const SizedBox.shrink();
    }

    return TeXWidget(
      math: r"$$" + math! + r"$$",
      displayFormulaWidgetBuilder: (context, formula) {
        return Center(
          child: TeX2SVG(
            math: formula,
            formulaWidgetBuilder: (context, svg) {
              return SvgPicture.string(
                svg,
                height: displaySize,
                width: displaySize,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              );
            },
          ),
        );
      },
      inlineFormulaWidgetBuilder: (context, formula) {
        return TeX2SVG(
          math: formula,
          formulaWidgetBuilder: (context, svg) {
            return SvgPicture.string(
              svg,
              height: inlineSize,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            );
          },
        );
      },
    );
  }
}
