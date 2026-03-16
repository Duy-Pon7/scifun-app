enum SubjectThemeType { physics, chemistry, biology }

class SubjectThemeHelper {
  SubjectThemeHelper._();

  static SubjectThemeType resolveTheme(String? subjectName) {
    if (isBiology(subjectName)) {
      return SubjectThemeType.biology;
    }
    if (isChemistry(subjectName)) {
      return SubjectThemeType.chemistry;
    }
    return SubjectThemeType.physics;
  }

  static bool isPhysics(String? subjectName) {
    final normalized = _normalize(subjectName);
    return _containsAny(normalized, const [
      'vật lý',
      'vật lí',
      'vat ly',
      'vat li',
      'physics',
    ]);
  }

  static bool isChemistry(String? subjectName) {
    final normalized = _normalize(subjectName);
    return _containsAny(normalized, const [
      'hóa học',
      'hoá học',
      'hoa hoc',
      'hóa',
      'hoá',
      'hoa',
      'chemistry',
      'chem',
    ]);
  }

  static bool isBiology(String? subjectName) {
    final normalized = _normalize(subjectName);
    return _containsAny(normalized, const [
      'sinh học',
      'sinh hoc',
      'sinh',
      'biology',
      'bio',
    ]);
  }

  static String _normalize(String? value) {
    return (value ?? '').trim().toLowerCase();
  }

  static bool _containsAny(String value, List<String> patterns) {
    for (final pattern in patterns) {
      if (value.contains(pattern)) {
        return true;
      }
    }
    return false;
  }
}
