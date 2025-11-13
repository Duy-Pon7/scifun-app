import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget child;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Color borderColor;
  final IconData iconExpand;
  final IconData iconCollapse;
  final Color iconColor;
  final double titleFontSize;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.borderColor = Colors.grey,
    this.iconExpand = Icons.expand_more,
    this.iconCollapse = Icons.expand_less,
    this.iconColor = Colors.black,
    this.titleFontSize = 16.0,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tiêu đề
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: _isExpanded ? AppColor.primary600 : widget.borderColor,
              width: 1.5,
            ),
          ),
          child: InkWell(
            borderRadius: widget.borderRadius,
            onTap: _toggleExpanded,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: widget.titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? widget.iconCollapse : widget.iconExpand,
                    color: widget.iconColor,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Nội dung khi mở
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50], // hoặc giữ trắng nếu bạn muốn
                borderRadius: widget.borderRadius,
                border: Border.all(
                  color: AppColor.border,
                  width: 1.w,
                ),
              ),
              child: widget.child,
            ),
          ),
      ],
    );
  }
}
