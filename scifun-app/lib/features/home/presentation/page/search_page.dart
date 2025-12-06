import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/common/widget/topic_item_lesson.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/topic/presentation/pages/topic_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_entity.dart';
import 'package:sci_fun/features/home/presentation/page/lesson_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  late SharePrefsService _prefsService;
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _prefsService = SharePrefsService(prefs: prefs);
    _loadSearchHistory();
  }

  void _searchAction() {}
  void _loadSearchHistory() {
    final history = _prefsService.getSearchHistory();
    setState(() {
      _searchHistory = history;
    });
  }

  void _saveSearch(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _searchHistory.remove(text); // tránh trùng lặp
      _searchHistory.insert(0, text); // thêm đầu danh sách
      if (_searchHistory.length > 4) {
        _searchHistory = _searchHistory.sublist(0, 4); // giới hạn 10 mục
      }
    });
    _prefsService.saveSearchHistory(_searchHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: "Chi tiết lịch sử gói cước",
        showTitle: true,
        showBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _inputSearch(),
            SizedBox(height: 24.h),
            Text(
              'Tìm kiếm gần đây',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: _searchHistory.isNotEmpty
                  ? _searchHistory.take(4).map((e) => _buildTag(e)).toList()
                  : [
                      Text(
                        "Chưa có lịch sử tìm kiếm",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputSearch() {
    return StatefulBuilder(
      builder: (context, setState) {
        return BasicInputField(
          controller: _controller,
          fillColor: AppColor.hurricane500.withValues(alpha: 0.12),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 7.w),
            child: Icon(
              Icons.search_rounded,
              color: AppColor.hurricane800.withValues(alpha: 0.6),
            ),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _controller.clear();
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 7.w),
                    child: Icon(
                      Icons.cancel,
                      color: AppColor.hurricane800.withValues(alpha: 0.6),
                    ),
                  ),
                )
              : null,
          hintText: "Tìm bài học",
          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17.sp,
                color: AppColor.hurricane800.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          onChanged: (value) {
            setState(() {}); // cập nhật UI cho icon clear
          },
          onEditingComplete: () {
            final text = _controller.text.trim();
            print(text);
            if (text.isNotEmpty) {
              _saveSearch(text);
              _controller.clear();
            }
          },
        );
      },
    );
  }

  Widget _buildTag(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, color: Colors.red, size: 24.sp),
            SizedBox(width: 12.w),
            Text(text,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
