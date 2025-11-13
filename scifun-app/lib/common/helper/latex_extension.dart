import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LatexExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {"latex"};

  @override
  InlineSpan build(ExtensionContext context) {
    String texSource = context.innerHtml.trim();
    MathStyle style = MathStyle.text;

    if (texSource.startsWith(r'$$') && texSource.endsWith(r'$$')) {
      texSource = texSource.substring(2, texSource.length - 2);
      style = MathStyle.display;
    } else if (texSource.startsWith(r'\(') && texSource.endsWith(r'\)')) {
      texSource = texSource.substring(2, texSource.length - 2);
      style = MathStyle.text;
    }

    return WidgetSpan(
      child: Math.tex(
        texSource,
        mathStyle: style,
        textStyle: TextStyle(fontSize: 22.sp),
        onErrorFallback: (e) => Text("Lỗi LaTeX: ${e.message}"),
      ),
    );
  }
}

/// Tiền xử lý: bọc các biểu thức \(...\) hoặc $$...$$ thành <latex>…</latex>
String preprocessLatex(String html) {
  var result = html;

  // display math $$...$$
  result = result.replaceAllMapped(
    RegExp(r"\$\$(.+?)\$\$", dotAll: true),
    (m) => "<latex>${m.group(0)}</latex>",
  );

  // inline math \(...\)
  result = result.replaceAllMapped(
    RegExp(r"\\\((.+?)\\\)", dotAll: true),
    (m) => "<latex>${m.group(0)}</latex>",
  );

  return result;
}
