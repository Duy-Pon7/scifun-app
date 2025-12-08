import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class CustomExpansionTileLesson extends StatefulWidget {
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

  const CustomExpansionTileLesson({
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
  });

  @override
  State<CustomExpansionTileLesson> createState() =>
      _CustomExpansionTileLessonState();
}

class _CustomExpansionTileLessonState extends State<CustomExpansionTileLesson> {
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
              color: AppColor.border,
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
                  // Icon + Tiêu đề
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_open, // hoặc Icons.topic_outlined
                          color: AppColor.primary600, // giống ảnh bạn gửi
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: widget.titleFontSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Số lượng bài hoàn thành
                  Text(
                    '${widget.completedCount}/${widget.children.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Icon mở rộng
                  Icon(
                    _isExpanded ? widget.iconCollapse : widget.iconExpand,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Nội dung khi mở
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.only(
              top: 6.h,
              bottom: 16.h,
              left: 16.w,
              right: 16.w,
            ),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ),
      ],
    );
  }
}
