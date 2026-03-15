import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';
import 'package:sci_fun/features/topic/presentation/pages/topic_page.dart';

class SubjectFocusOnboardingPage extends StatefulWidget {
  const SubjectFocusOnboardingPage({super.key});

  @override
  State<SubjectFocusOnboardingPage> createState() =>
      _SubjectFocusOnboardingPageState();
}

class _SubjectFocusOnboardingPageState
    extends State<SubjectFocusOnboardingPage> {
  final ScrollController _levelScrollController = ScrollController();

  static const List<_LevelOption> _levelOptions = [
    _LevelOption(
      index: 0,
      activeBars: 1,
      label: 'Tôi mới bắt đầu với môn này',
    ),
    _LevelOption(
      index: 1,
      activeBars: 2,
      label: 'Tôi biết các kiến thức cơ bản',
    ),
    _LevelOption(
      index: 2,
      activeBars: 3,
      label: 'Tôi làm tốt các bài tập mức cơ bản',
    ),
    _LevelOption(
      index: 3,
      activeBars: 4,
      label: 'Tôi tự tin với hầu hết chủ đề',
    ),
    _LevelOption(
      index: 4,
      activeBars: 4,
      label: 'Tôi muốn học chuyên sâu hơn',
    ),
  ];

  SubjectEntity? _selectedSubject;
  _LevelOption? _selectedLevel;

  bool get _canContinue => _selectedSubject != null && _selectedLevel != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final subjectCubit = context.read<SubjectCubit>();
      final state = subjectCubit.state;

      if (state is PaginationSuccess<SubjectEntity>) {
        _selectFirstSubjectIfNeeded(state.items);
        return;
      }

      if (state is! PaginationLoading<SubjectEntity> &&
          state is! PaginationLoadingMore<SubjectEntity>) {
        subjectCubit.loadInitial(searchQuery: '');
      }
    });
  }

  @override
  void dispose() {
    _levelScrollController.dispose();
    super.dispose();
  }

  void _selectFirstSubjectIfNeeded(List<SubjectEntity> subjects) {
    if (!mounted || _selectedSubject != null || subjects.isEmpty) {
      return;
    }

    setState(() {
      _selectedSubject = subjects.first;
    });
  }

  Future<void> _showSubjectSwitcher() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0A2333),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
            builder: (context, state) {
              if (state is PaginationLoading<SubjectEntity>) {
                return SizedBox(
                  height: 220.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (state is PaginationSuccess<SubjectEntity>) {
                final subjects = state.items
                    .where((subject) => (subject.id ?? '').isNotEmpty)
                    .toList();

                if (subjects.isEmpty) {
                  return SizedBox(
                    height: 220.h,
                    child: Center(
                      child: Text(
                        'Chưa có môn học',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 420.h,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Chọn môn đang muốn chú ý',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: subjects.length,
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                          separatorBuilder: (_, __) => SizedBox(height: 8.h),
                          itemBuilder: (_, index) {
                            final subject = subjects[index];
                            final isSelected =
                                subject.id == _selectedSubject?.id;
                            final subjectName =
                                subject.name?.trim().isNotEmpty == true
                                    ? subject.name!.trim()
                                    : 'Môn học';

                            return InkWell(
                              borderRadius: BorderRadius.circular(14.r),
                              onTap: () {
                                setState(() {
                                  _selectedSubject = subject;
                                });
                                Navigator.of(sheetContext).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF11415C)
                                      : const Color(0xFF0E3347),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF37BFFF)
                                        : const Color(0xFF325B72),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        subjectName,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? const Color(0xFF3FD0FF)
                                          : Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox(
                height: 220.h,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<SubjectCubit>().loadInitial(searchQuery: '');
                    },
                    child: const Text('Tải lại danh sách môn'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _continueToSubject() async {
    final subject = _selectedSubject;
    final level = _selectedLevel;
    if (subject == null || level == null) {
      return;
    }

    final subjectId = subject.id ?? '';
    if (subjectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Môn học chưa hợp lệ, vui lòng chọn lại.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_focus_subject_id', subjectId);
    await prefs.setString(
      'onboarding_focus_subject_name',
      subject.name ?? '',
    );
    await prefs.setInt('onboarding_focus_level_index', level.index);
    await prefs.setString('onboarding_focus_level_label', level.label);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TopicPage(
          subjectId: subjectId,
          subjectName: subject.name ?? 'Môn học',
        ),
      ),
    );
  }

  Widget _buildCharacterAndQuestion() {
    final subjectName = _selectedSubject?.name?.trim();
    final question = subjectName != null && subjectName.isNotEmpty
        ? 'Mức độ của bạn với môn $subjectName ở mức nào?'
        : 'Bạn muốn tập trung vào môn nào?';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 86.w,
          height: 86.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2D556E), width: 1.w),
          ),
          child: ClipOval(
            child: Lottie.asset(
              'assets/lottie_json/cat.json',
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0D2738),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFF2D556E), width: 1.w),
            ),
            child: Text(
              question,
              style: TextStyle(
                fontSize: 22.sp,
                height: 1.35,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectSelector() {
    return BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
      builder: (context, state) {
        final isLoading = state is PaginationLoading<SubjectEntity>;
        final canOpenSelector = state is PaginationSuccess<SubjectEntity>;
        final subjectName = _selectedSubject?.name?.trim();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0A2231),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFF2D556E), width: 1.w),
          ),
          child: Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: const Color(0xFF39CFFF),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  subjectName != null && subjectName.isNotEmpty
                      ? subjectName
                      : 'Chọn môn học',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              else
                TextButton.icon(
                  onPressed: canOpenSelector ? _showSubjectSwitcher : null,
                  icon: Icon(
                    Icons.swap_horiz_rounded,
                    size: 18.sp,
                    color: const Color(0xFF51D7FF),
                  ),
                  label: Text(
                    'Đổi môn',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF51D7FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelList() {
    return Scrollbar(
      controller: _levelScrollController,
      thumbVisibility: true,
      radius: Radius.circular(8.r),
      child: ListView.separated(
        controller: _levelScrollController,
        padding: EdgeInsets.only(right: 6.w),
        itemCount: _levelOptions.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, index) {
          final option = _levelOptions[index];
          final isSelected = _selectedLevel == option;

          return InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              setState(() {
                _selectedLevel = option;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF11415C)
                    : const Color(0xFF0A2434),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF38C0FF)
                      : const Color(0xFF33576C),
                  width: 1.2.w,
                ),
              ),
              child: Row(
                children: [
                  _LevelBars(
                    activeBars: option.activeBars,
                    highlight: isSelected,
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: const Color(0xFF41D0FF),
                      size: 22.sp,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomAction() {
    final enabled = _canContinue;
    final buttonColor =
        enabled ? const Color(0xFF3E5E71) : const Color(0xFF2B3D4A);
    final textColor =
        enabled ? Colors.white : const Color(0xFF7F97A8).withValues(alpha: 0.9);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: const Color(0xFF051824),
        border: Border(
          top: BorderSide(color: const Color(0xFF2E4A5D), width: 1.w),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          SizedBox(
            width: 170.w,
            child: BasicButton(
              text: 'TIẾP TỤC',
              onPressed: enabled ? _continueToSubject : () {},
              backgroundColor: buttonColor,
              textColor: textColor,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(16.r),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectCubit, PaginationState<SubjectEntity>>(
      listener: (context, state) {
        if (state is PaginationSuccess<SubjectEntity>) {
          _selectFirstSubjectIfNeeded(state.items);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF061A27),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A2A3C),
                Color(0xFF061A27),
                Color(0xFF04141F),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCharacterAndQuestion(),
                        SizedBox(height: 14.h),
                        _buildSubjectSelector(),
                        SizedBox(height: 14.h),
                        Text(
                          'Chọn mức độ hiện tại',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Expanded(child: _buildLevelList()),
                      ],
                    ),
                  ),
                ),
                _buildBottomAction(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelBars extends StatelessWidget {
  const _LevelBars({
    required this.activeBars,
    required this.highlight,
  });

  final int activeBars;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final isActive = index < activeBars;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 5.w,
            height: (10 + index * 4).h,
            decoration: BoxDecoration(
              color: isActive
                  ? (highlight
                      ? const Color(0xFF42D2FF)
                      : const Color(0xFF26B9F4))
                  : const Color(0xFF1D4258),
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }),
      ),
    );
  }
}

class _LevelOption {
  const _LevelOption({
    required this.index,
    required this.label,
    required this.activeBars,
  });

  final int index;
  final String label;
  final int activeBars;
}
