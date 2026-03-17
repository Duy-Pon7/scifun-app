import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/features/home/presentation/page/dashboard_page.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class SubjectFocusOnboardingPage extends StatefulWidget {
  const SubjectFocusOnboardingPage({super.key});

  @override
  State<SubjectFocusOnboardingPage> createState() =>
      _SubjectFocusOnboardingPageState();
}

class _SubjectFocusOnboardingPageState
    extends State<SubjectFocusOnboardingPage> {
  static const int _totalSteps = 3;

  static const List<String> _ageRanges = [
    '<5',
    '5-8',
    '9-12',
    '13-15',
    '16-18',
    '+18',
  ];

  static const List<String> _discoveryPlatforms = [
    'Facebook',
    'TikTok',
    'YouTube',
    'Instagram',
    'Bạn bè',
    'Khác',
  ];

  static const String _prefsInterestSubjectId =
      'onboarding_interest_subject_id';
  static const String _prefsAgeRange = 'onboarding_age_range';
  static const String _prefsReferralPlatform = 'onboarding_referral_platform';

  final PageController _pageController = PageController();

  SubjectEntity? _selectedSubject;
  String? _selectedAgeRange;
  String? _selectedDiscoveryPlatform;
  int _currentStep = 0;
  bool _isSubmitting = false;

  static const Color _surfaceColor = Colors.white;
  static const Color _borderColor = Color(0xFFD6DADF);
  static const Color _textPrimaryColor = Color(0xFF3F4348);
  static const Color _textSecondaryColor = Color(0xFF8D949C);
  static const Color _selectedFillColor = Color(0xFFD9F0FF);
  static const Color _selectedBorderColor = Color(0xFF70C5EE);
  static const Color _selectedTextColor = Color(0xFF2092CA);
  static const Color _disabledActionColor = Color(0xFFE4E4E4);

  bool get _canContinueCurrentStep {
    switch (_currentStep) {
      case 0:
        return _selectedSubject != null;
      case 1:
        return _selectedAgeRange != null;
      case 2:
        return _selectedDiscoveryPlatform != null;
      default:
        return false;
    }
  }

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
    _pageController.dispose();
    super.dispose();
  }

  void _selectFirstSubjectIfNeeded(List<SubjectEntity> subjects) {
    if (!mounted || _selectedSubject != null || subjects.isEmpty) {
      return;
    }

    SubjectEntity? firstValidSubject;
    for (final subject in subjects) {
      if ((subject.id ?? '').isNotEmpty) {
        firstValidSubject = subject;
        break;
      }
    }

    if (firstValidSubject == null) {
      return;
    }

    setState(() {
      _selectedSubject = firstValidSubject;
    });
  }

  Future<void> _goNextStep() async {
    if (_isSubmitting) {
      return;
    }

    if (!_canContinueCurrentStep) {
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      await _pageController.animateToPage(
        _currentStep + 1,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeInOut,
      );
      return;
    }

    await _finishOnboarding();
  }

  Future<void> _goBackStep() async {
    if (_isSubmitting) {
      return;
    }

    if (_currentStep == 0) {
      return;
    }

    await _pageController.animateToPage(
      _currentStep - 1,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
    );
  }

  String _mapSubjectForOnboarding(String? subjectName) {
    final name = (subjectName ?? '').trim();
    final normalized = name.toLowerCase();

    if (normalized.contains('lý') ||
        normalized.contains('lí') ||
        normalized.contains('ly') ||
        normalized.contains('li') ||
        normalized.contains('physics')) {
      return 'Lý';
    }

    if (normalized.contains('hóa') ||
        normalized.contains('hoá') ||
        normalized.contains('hoa') ||
        normalized.contains('chem')) {
      return 'Hóa';
    }

    if (normalized.contains('sinh') || normalized.contains('bio')) {
      return 'Sinh';
    }

    return name;
  }

  String _extractOnboardingErrorMessage(Object error) {
    if (error is DioException) {
      final resData = error.response?.data;
      if (resData is Map<String, dynamic>) {
        final message = (resData['message'] ?? '').toString().trim();
        if (message.isNotEmpty) {
          return message;
        }
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return 'Không thể kết nối máy chủ, vui lòng thử lại.';
      }

      final fallback = (error.message ?? '').trim();
      if (fallback.isNotEmpty) {
        return fallback;
      }
    }

    final fallback = error.toString().trim();
    if (fallback.isNotEmpty) {
      return fallback.replaceFirst('Exception: ', '');
    }

    return 'Lưu thông tin onboarding thất bại.';
  }

  Future<void> _finishOnboarding() async {
    final subject = _selectedSubject;
    final ageRange = _selectedAgeRange;
    final referralPlatform = _selectedDiscoveryPlatform;

    if (subject == null || ageRange == null || referralPlatform == null) {
      return;
    }

    final subjectId = subject.id ?? '';
    if (subjectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Môn học chưa hợp lệ, vui lòng chọn lại.'),
        ),
      );
      return;
    }

    final subjectName = subject.name?.trim().isNotEmpty == true
        ? subject.name!.trim()
        : 'Môn học';

    if (mounted) {
      setState(() {
        _isSubmitting = true;
      });
    }

    try {
      final response = await sl<DioClient>().post(
        url: OnboardingApiUrls.submit,
        data: {
          'subject': _mapSubjectForOnboarding(subjectName),
          'ageGroup': ageRange,
          'referralSource': referralPlatform,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final apiStatus = data['status'];
        if (apiStatus is num && apiStatus.toInt() != 200) {
          final message = (data['message'] ?? '').toString().trim();
          throw Exception(
            message.isNotEmpty ? message : 'Lưu thông tin onboarding thất bại.',
          );
        }
      }

      final statusCode = response.statusCode ?? 500;
      if (statusCode < 200 || statusCode >= 300) {
        throw Exception('Lưu thông tin onboarding thất bại.');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsInterestSubjectId, subjectId);
      await prefs.setString(_prefsAgeRange, ageRange);
      await prefs.setString(_prefsReferralPlatform, referralPlatform);

      // Xóa khóa onboarding cũ để tránh dữ liệu cũ.
      await prefs.remove('onboarding_focus_subject_id');
      await prefs.remove('onboarding_focus_subject_name');
      await prefs.remove('onboarding_focus_level_index');
      await prefs.remove('onboarding_focus_level_label');

      await sl<SharePrefsService>().saveSelectedSubject(
        subjectId: subjectId,
        subjectName: subjectName,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_extractOnboardingErrorMessage(e)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _getQuestionForStep() {
    switch (_currentStep) {
      case 0:
        return 'Bạn đang hứng thú với môn học nào?';
      case 1:
        return 'Bạn đang ở độ tuổi bao nhiêu?';
      case 2:
        return 'Bạn biết đến ứng dụng từ nền tảng nào?';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        Text(
          'Bước ${_currentStep + 1}/$_totalSteps',
          style: TextStyle(
            fontSize: 13.sp,
            color: _textSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Row(
            children: List.generate(_totalSteps, (index) {
              final isDone = index <= _currentStep;
              return Expanded(
                child: Container(
                  height: 5.h,
                  margin: EdgeInsets.only(
                    right: index == _totalSteps - 1 ? 0 : 6.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color:
                        isDone ? _selectedTextColor : const Color(0xFFE7EAEE),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterAndQuestion() {
    final question = _getQuestionForStep();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140.w,
          height: 140.w,
          child: Center(
            child: Lottie.asset(
              'assets/lottie_json/cat.json',
              repeat: true,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: _borderColor, width: 1.w),
            ),
            child: Text(
              question,
              style: TextStyle(
                fontSize: 21.sp,
                height: 1.35,
                color: _textPrimaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getSubjectFallbackImage(String? subjectName) {
    final normalized = (subjectName ?? '').trim().toLowerCase();

    if (normalized.contains('toán') ||
        normalized.contains('toan') ||
        normalized.contains('math')) {
      return AppImage.math;
    }
    if (normalized.contains('văn') ||
        normalized.contains('van') ||
        normalized.contains('ngữ văn') ||
        normalized.contains('literature')) {
      return AppImage.literature;
    }
    if (normalized.contains('anh') || normalized.contains('english')) {
      return AppImage.english;
    }
    if (normalized.contains('lý') ||
        normalized.contains('ly') ||
        normalized.contains('physics')) {
      return AppImage.lesson;
    }
    if (normalized.contains('hóa') ||
        normalized.contains('hoa') ||
        normalized.contains('chem')) {
      return AppImage.examineTest;
    }
    if (normalized.contains('sinh') || normalized.contains('bio')) {
      return AppImage.knowledgeLearn;
    }
    return AppImage.lesson;
  }

  Widget _buildSubjectImage(
    SubjectEntity subject, {
    required Color backgroundColor,
    required Color borderColor,
  }) {
    final fallbackImage = _getSubjectFallbackImage(subject.name);
    final imageUrl = (subject.image ?? '').trim();
    final hasNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Container(
      width: 44.w,
      height: 44.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: hasNetworkImage
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Image.asset(fallbackImage, fit: BoxFit.cover),
              )
            : Image.asset(fallbackImage, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildEmptySubjectState({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _borderColor, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 10.h),
            BasicButton(
              text: actionLabel,
              onPressed: onAction,
              width: 120.w,
              border: true,
              borderColor: _selectedBorderColor,
              borderWidth: 1.w,
              backgroundColor: _surfaceColor,
              textColor: _selectedTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              borderRadius: BorderRadius.circular(12.r),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              buttonHeight: 3,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubjectTile(SubjectEntity subject) {
    final isSelected = subject.id == _selectedSubject?.id;
    final subjectName = subject.name?.trim().isNotEmpty == true
        ? subject.name!.trim()
        : 'Môn học';
    final accentColor = AppColor.subject600(subject.name);
    final pressedAccentColor = AppColor.subject700(subject.name);
    final softAccentColor = AppColor.subject100(subject.name);
    final tileBackgroundColor = isSelected ? accentColor : softAccentColor;
    final tileButtonColor = isSelected ? pressedAccentColor : accentColor;
    final tileTextColor = isSelected ? Colors.white : accentColor;
    final tileBorderColor =
        isSelected ? pressedAccentColor : accentColor.withValues(alpha: 0.45);
    final imageBackgroundColor =
        isSelected ? Colors.white.withValues(alpha: 0.16) : _surfaceColor;
    final imageBorderColor = isSelected
        ? Colors.white.withValues(alpha: 0.5)
        : accentColor.withValues(alpha: 0.35);

    return BasicButton(
      onPressed: () {
        setState(() {
          _selectedSubject = subject;
        });
      },
      width: double.infinity,
      border: true,
      borderColor: tileBorderColor,
      borderWidth: 1.w,
      backgroundColor: tileBackgroundColor,
      buttonColor: tileButtonColor,
      textColor: tileTextColor,
      borderRadius: BorderRadius.circular(14.r),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      buttonHeight: 3,
      child: Row(
        children: [
          _buildSubjectImage(
            subject,
            backgroundColor: imageBackgroundColor,
            borderColor: imageBorderColor,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              subjectName,
              style: TextStyle(
                fontSize: 16.sp,
                color: tileTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            isSelected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: isSelected
                ? Colors.white.withValues(alpha: 0.95)
                : accentColor.withValues(alpha: 0.75),
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelector() {
    return BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
      builder: (context, state) {
        if (state is PaginationLoading<SubjectEntity> ||
            state is PaginationLoadingMore<SubjectEntity>) {
          return Center(
            child: CircularProgressIndicator(
              color: _selectedTextColor,
            ),
          );
        }

        if (state is PaginationSuccess<SubjectEntity>) {
          final subjects = state.items
              .where((subject) => (subject.id ?? '').isNotEmpty)
              .toList();

          if (subjects.isEmpty) {
            return _buildEmptySubjectState(message: 'Chưa có môn học');
          }

          return ListView.separated(
            itemCount: subjects.length,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (_, index) => _buildSubjectTile(subjects[index]),
          );
        }

        return _buildEmptySubjectState(
          message: 'Không tải được danh sách môn học.',
          actionLabel: 'Tải lại',
          onAction: () {
            context.read<SubjectCubit>().loadInitial(searchQuery: '');
          },
        );
      },
    );
  }

  Widget _buildSubjectStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Môn học bạn muốn học nhiều hơn',
          style: TextStyle(
            fontSize: 14.sp,
            color: _textSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(child: _buildSubjectSelector()),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: _borderColor, width: 1.w),
          ),
          child: Text(
            'Bạn có thể thay đổi lựa chọn này bất kỳ lúc nào.',
            style: TextStyle(
              fontSize: 13.sp,
              color: _textSecondaryColor,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceStep({
    required String helperText,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          helperText,
          style: TextStyle(
            fontSize: 14.sp,
            color: _textSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (_, index) {
              final option = options[index];
              final isSelected = option == selectedValue;
              return _buildOptionTile(
                label: option,
                isSelected: isSelected,
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return BasicButton(
      onPressed: onTap,
      width: double.infinity,
      border: true,
      borderColor: isSelected ? _selectedBorderColor : _borderColor,
      borderWidth: 1.w,
      backgroundColor: isSelected ? _selectedFillColor : _surfaceColor,
      textColor: isSelected ? _selectedTextColor : _textPrimaryColor,
      borderRadius: BorderRadius.circular(14.r),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      buttonHeight: 3,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: isSelected ? _selectedTextColor : _textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            isSelected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: isSelected ? _selectedTextColor : _textSecondaryColor,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (page) {
        setState(() {
          _currentStep = page;
        });
      },
      children: [
        _buildSubjectStep(),
        _buildChoiceStep(
          helperText: 'Chọn nhóm tuổi phù hợp với bạn',
          options: _ageRanges,
          selectedValue: _selectedAgeRange,
          onSelected: (value) {
            setState(() {
              _selectedAgeRange = value;
            });
          },
        ),
        _buildChoiceStep(
          helperText: 'Bạn biết đến ứng dụng qua kênh nào',
          options: _discoveryPlatforms,
          selectedValue: _selectedDiscoveryPlatform,
          onSelected: (value) {
            setState(() {
              _selectedDiscoveryPlatform = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    final enabled = _canContinueCurrentStep && !_isSubmitting;
    final nextButtonColor =
        enabled ? AppColor.skyblue500 : _disabledActionColor;
    final nextTextColor = enabled
        ? Colors.white
        : const Color(0xFFA9AFB6).withValues(alpha: 0.95);
    final isLastStep = _currentStep == _totalSteps - 1;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: _surfaceColor,
        border: Border(
          top: BorderSide(color: _borderColor, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            SizedBox(
              width: 118.w,
              child: BasicButton(
                text: 'QUAY LẠI',
                onPressed: () {
                  if (_isSubmitting) {
                    return;
                  }
                  _goBackStep();
                },
                border: true,
                borderColor: _borderColor,
                borderWidth: 1.w,
                backgroundColor: _surfaceColor,
                textColor: _textPrimaryColor,
                fontWeight: FontWeight.w700,
                borderRadius: BorderRadius.circular(16.r),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                buttonHeight: 3,
              ),
            ),
            SizedBox(width: 10.w),
          ] else
            const Spacer(),
          SizedBox(
            width: _currentStep > 0 ? 170.w : 180.w,
            child: BasicButton(
              text: isLastStep
                  ? (_isSubmitting ? 'ĐANG GỬI...' : 'HOÀN TẤT')
                  : 'TIẾP TỤC',
              onPressed: enabled ? _goNextStep : () {},
              backgroundColor: nextButtonColor,
              textColor: nextTextColor,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(16.r),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              buttonHeight: 3,
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
        backgroundColor: _surfaceColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressIndicator(),
                      SizedBox(height: 12.h),
                      _buildCharacterAndQuestion(),
                      SizedBox(height: 14.h),
                      Expanded(child: _buildStepContent()),
                    ],
                  ),
                ),
              ),
              _buildBottomAction(),
            ],
          ),
        ),
      ),
    );
  }
}
