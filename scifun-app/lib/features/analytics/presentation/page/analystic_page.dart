import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/features/analytics/presentation/components/list_analystics.dart';

class AnalysticPage extends StatefulWidget {
  const AnalysticPage({super.key});

  @override
  State<AnalysticPage> createState() => _AnalysticPageState();
}

class _AnalysticPageState extends State<AnalysticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Thống kê",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            spacing: 16.h,
            children: [ListAnalystics()],
          ),
        ),
      ),
    );
  }
}
