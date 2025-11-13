import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/is_expire_token.dart';

class CheckTokenInterceptor extends Interceptor {
  final SharePrefsService _sharePrefsService;

  final Set<String> _noAuthPaths = {
    AuthApiUrls.login,
    AuthApiUrls.resetPassword,
    AuthApiUrls.sendEmail,
    AuthApiUrls.signup,
    AuthApiUrls.verifyOtp,
    HomeApiUrls.getNews,
    SubjectApiUrl.getSubjects,
    HomeApiUrls.getLessonCategory,
  };

  CheckTokenInterceptor({required SharePrefsService sharePrefsService})
      : _sharePrefsService = sharePrefsService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_noAuthPaths.contains(options.path)) {
      if (isExpireToken(_sharePrefsService.getAuthToken())) {
        log('Token "${_sharePrefsService.getAuthToken()}" is expire!');
      } else {
        options.headers['Authorization'] =
            'Bearer ${_sharePrefsService.getAuthToken()}';
      }
    }
    super.onRequest(options, handler);
  }
}
