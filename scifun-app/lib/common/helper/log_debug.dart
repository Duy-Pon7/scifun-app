import 'package:flutter/foundation.dart';

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _threeDigits(int value) => value.toString().padLeft(3, '0');

String _formatTimestamp(DateTime time) {
  final date = '${time.year}-${_twoDigits(time.month)}-${_twoDigits(time.day)}';
  final clock =
      '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}:${_twoDigits(time.second)}';
  final ms = _threeDigits(time.millisecond);
  return '$date $clock.$ms';
}

String _resolveFeatureIcon(String source, {String? icon}) {
  if (icon != null && icon.trim().isNotEmpty) {
    return icon.trim();
  }

  final sourceText = source.toLowerCase();

  if (sourceText.contains('auth')) {
    return '🔐';
  }
  if (sourceText.contains('notification')) {
    return '🔔';
  }
  if (sourceText.contains('leaderboard')) {
    return '🏆';
  }
  if (sourceText.contains('comment') || sourceText.contains('chat')) {
    return '💬';
  }
  if (sourceText.contains('news')) {
    return '📰';
  }
  if (sourceText.contains('lessoncategory') ||
      sourceText.contains('lesson_category')) {
    return '🗂️';
  }
  if (sourceText.contains('lesson')) {
    return '📘';
  }
  if (sourceText.contains('subject')) {
    return '📚';
  }
  if (sourceText.contains('topic')) {
    return '🧠';
  }
  if (sourceText.contains('progress') || sourceText.contains('analytics')) {
    return '📈';
  }
  if (sourceText.contains('plan') ||
      sourceText.contains('checkout') ||
      sourceText.contains('payment')) {
    return '💳';
  }
  if (sourceText.contains('package')) {
    return '🎁';
  }
  if (sourceText.contains('roadmap') || sourceText.contains('home')) {
    return '🗺️';
  }
  if (sourceText.contains('question') ||
      sourceText.contains('quiz') ||
      sourceText.contains('quizz')) {
    return '❓';
  }
  if (sourceText.contains('video')) {
    return '🎬';
  }
  if (sourceText.contains('user') || sourceText.contains('profile')) {
    return '👤';
  }
  if (sourceText.contains('activity')) {
    return '🎯';
  }
  if (sourceText.contains('character')) {
    return '🧙';
  }

  return '🧩';
}

void _logApi({
  required String source,
  required String statusLabel,
  required String statusIcon,
  Object? data,
  String? icon,
}) {
  if (!kDebugMode) {
    return;
  }

  final timestamp = _formatTimestamp(DateTime.now());
  final featureIcon = _resolveFeatureIcon(source, icon: icon);
  debugPrint(
    'Debug: $featureIcon $statusIcon [$timestamp] [$source] [$statusLabel] data: $data',
  );
}

void logApiSuccess({required String source, Object? data, String? icon}) {
  _logApi(
    source: source,
    statusLabel: 'success',
    statusIcon: '✅',
    data: data,
    icon: icon,
  );
}

void logApiFailure({required String source, Object? data, String? icon}) {
  _logApi(
    source: source,
    statusLabel: 'failure',
    statusIcon: '❌',
    data: data,
    icon: icon,
  );
}

void logApiCheckResult({
  required String source,
  required bool isCorrect,
  Object? data,
  String? icon,
}) {
  _logApi(
    source: source,
    statusLabel: isCorrect ? 'correct' : 'wrong',
    statusIcon: isCorrect ? '🎉' : '⚠️',
    data: data,
    icon: icon,
  );
}

void logResponseData(Object? responseData, {String? source, String? icon}) {
  _logApi(
    source: source?.trim().isNotEmpty == true ? source! : 'unknown-api',
    statusLabel: 'response',
    statusIcon: '📦',
    data: responseData,
    icon: icon,
  );
}
