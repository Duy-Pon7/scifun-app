class LevelHelper {
  const LevelHelper._();

  static const String beginner = 'Beginner';
  static const String intermediate = 'Intermediate';
  static const String advanced = 'Advanced';

  static const Map<String, String> vietnameseLabelsByValue = {
    beginner: 'Mới bắt đầu',
    intermediate: 'Trung cấp',
    advanced: 'Nâng cao',
  };

  static String? normalize(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) {
      return null;
    }

    final lower = raw.toLowerCase();
    if (_isBeginner(lower)) return beginner;
    if (_isIntermediate(lower)) return intermediate;
    if (_isAdvanced(lower)) return advanced;
    return raw;
  }

  static String toVietnamese(String? value) {
    final normalized = normalize(value);
    if (normalized == null) {
      return '';
    }
    return vietnameseLabelsByValue[normalized] ?? normalized;
  }

  static int? rank(String? value) {
    final normalized = normalize(value);
    if (normalized == beginner) return 1;
    if (normalized == intermediate) return 2;
    if (normalized == advanced) return 3;
    return null;
  }

  static bool _isBeginner(String lower) {
    return lower == 'beginner' ||
        lower == 'moi bat dau' ||
        lower == 'mới bắt đầu';
  }

  static bool _isIntermediate(String lower) {
    return lower == 'intermediate' ||
        lower == 'trung cap' ||
        lower == 'trung cấp';
  }

  static bool _isAdvanced(String lower) {
    return lower == 'advanced' || lower == 'nang cao' || lower == 'nâng cao';
  }
}
