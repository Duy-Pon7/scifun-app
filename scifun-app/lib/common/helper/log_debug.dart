String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _threeDigits(int value) => value.toString().padLeft(3, '0');

String _formatTimestamp(DateTime time) {
  final date = '${time.year}-${_twoDigits(time.month)}-${_twoDigits(time.day)}';
  final clock =
      '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}:${_twoDigits(time.second)}';
  final ms = _threeDigits(time.millisecond);
  return '$date $clock.$ms';
}

String _resolveFeatureIcon(
  String? source, {
  String? icon,
}) {
  if (icon != null && icon.trim().isNotEmpty) {
    return icon;
  }

  final sourceText = source?.toLowerCase() ?? '';

  if (sourceText.contains('auth')) return '🔐';
  if (sourceText.contains('news')) return '📰';
  if (sourceText.contains('package')) return '📦';
  if (sourceText.contains('question') || sourceText.contains('quiz')) {
    return '❓';
  }
  if (sourceText.contains('lesson')) return '📚';
  if (sourceText.contains('chat')) return '💬';
  if (sourceText.contains('profile')) return '👤';

  return '🧩';
}

void logResponseData(
  Object? responseData, {
  String? source,
  String? icon,
}) {
  final sourceLabel =
      source != null && source.trim().isNotEmpty ? '[$source]' : '';
  final timestamp = _formatTimestamp(DateTime.now());
  final featureIcon = _resolveFeatureIcon(source, icon: icon);
  print('$featureIcon [$timestamp] [responseData]$sourceLabel $responseData');
}
