import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/pro_cubit.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/quizz_cubit.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/question/presentation/page/test_page.dart';
import 'package:sci_fun/features/plan/presentation/page/plan_list_page.dart';

class QuizzPage extends StatefulWidget {
  final String topicId;
  final String topicName;

  const QuizzPage({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  late final QuizzCubit cubit;
  late final ProCubit proCubit;
  bool isProUser = false;

  @override
  void initState() {
    super.initState();
    cubit = sl<QuizzCubit>();
    proCubit = context.read<ProCubit>();
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    final token = sl<SharePrefsService>().getUserData();
    bool pro = false;

    try {
      if (token != null && token.isNotEmpty) {
        pro = await proCubit.isCheckPro(token: token);
      }
    } catch (_) {
      pro = false;
    }

    if (!mounted) return;
    setState(() => isProUser = pro);

    cubit.loadInitial(filterId: widget.topicId);
  }

  @override
  void didUpdateWidget(covariant QuizzPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topicId != widget.topicId) {
      cubit.loadInitial(filterId: widget.topicId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizzCubit>.value(
      value: cubit,
      child: Scaffold(
        appBar: BasicAppbar(
          title: widget.topicName,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: PaginationListView<QuizzEntity>(
            cubit: cubit,
            emptyWidget: const Center(
              child: Text('Không có bài kiểm tra'),
            ),
            itemBuilder: (context, quizz) {
              final bool isQuizPro = quizz.accessTier == 'PRO';
              final bool isLocked = isQuizPro && !isProUser;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color:
                        isQuizPro ? AppColor.primary600 : Colors.grey.shade300,
                    width: isQuizPro ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    ListTile(
                      leading: _buildLeading(quizz),
                      title: _buildTitle(quizz, isQuizPro),
                      subtitle: _buildSubtitle(quizz),
                      onTap: () {
                        // ✅ Không PRO: vẫn tap được nhưng chuyển sang page mua
                        if (isLocked) {
                          Navigator.push(
                            context,
                            slidePage(const PlanListPage()),
                          );
                          return;
                        }

                        // ✅ PRO hoặc FREE: vào bài test bình thường
                        Navigator.push(
                          context,
                          slidePage(
                            TestPage(
                              quizzId: quizz.id ?? '',
                            ),
                          ),
                        );
                      },
                    ),

                    /// ⭐ PRO icon
                    if (isQuizPro)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Icon(
                          Icons.star,
                          color: AppColor.primary600,
                          size: 18.sp,
                        ),
                      ),

                    /// 🔒 Lock overlay (không chặn tap)
                    if (isLocked)
                      Positioned.fill(
                        child: IgnorePointer(
                          ignoring: true, // ✅ cho phép tap xuyên qua overlay
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.lock,
                                size: 36,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ===================== UI PART =====================

  Widget _buildLeading(QuizzEntity quizz) {
    if (quizz.topic?.subject?.image != null &&
        (quizz.topic?.subject?.image ?? '').isNotEmpty) {
      return SizedBox(
        width: 56.w,
        height: 56.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            quizz.topic!.subject!.image!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
        ),
      );
    }
    return Icon(Icons.quiz, color: AppColor.primary600);
  }

  Widget _buildTitle(QuizzEntity quizz, bool isQuizPro) {
    return Row(
      children: [
        Expanded(
          child: Text(
            quizz.title ?? 'No title',
            style: TextStyle(
              fontWeight: isQuizPro ? FontWeight.bold : FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isQuizPro ? AppColor.primary600 : Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            isQuizPro ? 'PRO' : 'FREE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(QuizzEntity quizz) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (quizz.description != null)
          Text(
            quizz.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
          ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(Icons.timer, size: 14.sp, color: AppColor.primary600),
            SizedBox(width: 6.w),
            Text('${quizz.duration ?? 0} phút',
                style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 12.w),
            Icon(Icons.help_outline, size: 14.sp, color: AppColor.primary600),
            SizedBox(width: 6.w),
            Text('${quizz.questionCount ?? 0} câu',
                style: TextStyle(fontSize: 12.sp)),
            if (quizz.uniqueUserCount != null &&
                quizz.uniqueUserCount! > 0) ...[
              SizedBox(width: 12.w),
              Icon(Icons.people, size: 14.sp, color: AppColor.primary600),
              SizedBox(width: 4.w),
              Text('${quizz.uniqueUserCount}',
                  style: TextStyle(fontSize: 12.sp)),
            ]
          ],
        ),
      ],
    );
  }
}
