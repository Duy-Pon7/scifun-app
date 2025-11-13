import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicDropdownField<T> extends StatelessWidget {
  const BasicDropdownField({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.hintText = 'Chọn dữ liệu',
    this.validator,
    this.suffixIcon,
    this.contentPadding,
    this.fillColor,
    this.borderRadius,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.enabled,
  });

  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final String Function(T) itemLabelBuilder;
  final String hintText;
  final String? Function(T?)? validator;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: enabled == false ? null : onChanged,
      validator: validator,
      isExpanded: true,
      icon: const SizedBox.shrink(), // ẩn mũi tên mặc định
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 14.sp,
          ),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        suffixIcon: suffixIcon ?? const Icon(Icons.expand_more),
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
        enabledBorder: enabledBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        focusedBorder: focusedBorder,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabelBuilder(item)),
        );
      }).toList(),
    );
  }
}
