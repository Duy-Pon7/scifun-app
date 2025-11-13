import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class CustomExpansionTileSubjects extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Color borderColor;
  final IconData iconExpand;
  final IconData iconCollapse;
  final Color iconColor;
  final double titleFontSize;
  final int completedCount;
  final int total;

  const CustomExpansionTileSubjects({
    super.key,
    required this.title,
    required this.children,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.borderColor = Colors.grey,
    this.iconExpand = Icons.expand_more,
    this.iconCollapse = Icons.expand_less,
    this.iconColor = Colors.black,
    this.titleFontSize = 16.0,
    required this.completedCount,
    required this.total,
  });

  @override
  State<CustomExpansionTileSubjects> createState() =>
      _CustomExpansionTileSubjectsState();
}

class _CustomExpansionTileSubjectsState
    extends State<CustomExpansionTileSubjects> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.total.toString();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        border: Border.all(
          color: AppColor.border,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: widget.borderRadius,
            onTap: _toggleExpanded,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dòng 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.folder_open,
                              color: Colors.red,
                              size: 22.sp,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "$t điểm",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // Dòng 2
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nội dung mở rộng
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),

          // Icon dropdown ở dưới, canh giữa
          GestureDetector(
            onTap: _toggleExpanded,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Icon(
                _isExpanded ? widget.iconCollapse : widget.iconExpand,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
