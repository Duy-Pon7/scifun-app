import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/features/home/presentation/page/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingGeneratingStructurePage extends StatefulWidget {
  const OnboardingGeneratingStructurePage({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.ageRange,
    required this.level,
    required this.referralPlatform,
    required this.prefsInterestSubjectIdKey,
    required this.prefsAgeRangeKey,
    required this.prefsLevelKey,
    required this.prefsReferralPlatformKey,
  });

  final String subjectId;
  final String subjectName;
  final String ageRange;
  final String level;
  final String referralPlatform;
  final String prefsInterestSubjectIdKey;
  final String prefsAgeRangeKey;
  final String prefsLevelKey;
  final String prefsReferralPlatformKey;

  @override
  State<OnboardingGeneratingStructurePage> createState() =>
      _OnboardingGeneratingStructurePageState();
}

class _OnboardingGeneratingStructurePageState
    extends State<OnboardingGeneratingStructurePage> {
  static const String _loadingMessage = 'Đang tạo cấu trúc kiến thức phù hợp';
  static const String _loadingLottieAssetPath =
      'assets/lottie_json/space_cat.json';
  static const Duration _holdBeforeNavigate = Duration(seconds: 5);

  bool _isSubmitting = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitOnboarding();
    });
  }

  String _mapSubjectForOnboarding(String subjectName) {
    final name = subjectName.trim();
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

  Future<void> _submitOnboarding() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final response = await sl<DioClient>().post(
        url: OnboardingApiUrls.submit,
        data: {
          'subject': _mapSubjectForOnboarding(widget.subjectName),
          'ageGroup': widget.ageRange,
          'level': widget.level,
          'referralSource': widget.referralPlatform,
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
      await prefs.setString(
        widget.prefsInterestSubjectIdKey,
        widget.subjectId,
      );
      await prefs.setString(widget.prefsAgeRangeKey, widget.ageRange);
      await prefs.setString(widget.prefsLevelKey, widget.level);
      await prefs.setString(
        widget.prefsReferralPlatformKey,
        widget.referralPlatform,
      );

      await prefs.remove('onboarding_focus_subject_id');
      await prefs.remove('onboarding_focus_subject_name');
      await prefs.remove('onboarding_focus_level_index');
      await prefs.remove('onboarding_focus_level_label');

      await sl<SharePrefsService>().saveSelectedSubject(
        subjectId: widget.subjectId,
        subjectName: widget.subjectName,
      );

      if (!mounted) {
        return;
      }

      await Future<void>.delayed(_holdBeforeNavigate);
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
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
        _errorMessage = _extractOnboardingErrorMessage(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _isSubmitting
                ? AppLoadingIndicator(
                    size: 300.w,
                    message: _loadingMessage,
                    lottieAssetPath: _loadingLottieAssetPath,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.error_outline_rounded,
                        color: Colors.red.shade400,
                        size: 40.sp,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        _errorMessage ?? 'Lưu thông tin onboarding thất bại.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.red.shade600,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FilledButton(
                        onPressed: _submitOnboarding,
                        child: const Text('Thử lại'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Text('Quay lại'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
