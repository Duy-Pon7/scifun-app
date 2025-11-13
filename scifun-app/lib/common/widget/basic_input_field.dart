import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicInputField extends StatelessWidget {
  const BasicInputField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText = 'Nhập dữ liệu',
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.contentPadding,
    this.obscureText = false,
    this.enabled,
    this.fillColor,
    this.maxLines = 1,
    this.readOnly = false,
    this.inputFormatters,
    this.borderRadius,
    this.onChanged,
    this.focusNode,
    this.onEditingComplete,
    this.prefixIcon,
    this.hintStyle,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.onTap,
    this.style,
  });
  final TextStyle? style;
  final VoidCallback? onTap;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool obscureText;
  final bool? enabled;
  final Color? fillColor;
  final int maxLines;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final BorderRadius? borderRadius;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      onTap: onTap,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
        filled: true,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        isDense: true,
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        prefixIconConstraints: BoxConstraints(
          minWidth: 30,
          minHeight: 20,
        ),
        enabledBorder: enabledBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        focusedBorder: focusedBorder,
      ),
      onEditingComplete: onEditingComplete,
    );
  }
}
