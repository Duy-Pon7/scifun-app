import 'package:flutter/material.dart';
import 'package:sci_fun/core/utils/subject_theme_helper.dart';

class AppColor {
  AppColor._();

  static SubjectThemeType _activeTheme = SubjectThemeType.physics;
  static final ValueNotifier<SubjectThemeType> themeNotifier =
      ValueNotifier<SubjectThemeType>(SubjectThemeType.physics);

  static SubjectThemeType get activeTheme => _activeTheme;

  static void applySubjectName(String? subjectName) {
    final resolvedTheme = SubjectThemeHelper.resolveTheme(subjectName);
    if (resolvedTheme == _activeTheme) {
      return;
    }
    _activeTheme = resolvedTheme;
    themeNotifier.value = resolvedTheme;
  }

  static void resetSubjectTheme() {
    if (_activeTheme == SubjectThemeType.physics) {
      return;
    }
    _activeTheme = SubjectThemeType.physics;
    themeNotifier.value = SubjectThemeType.physics;
  }

  static const Color physics50 = Color(0xFFECFEFF);
  static const Color physics100 = Color(0xFFCFFAFE);
  static const Color physics200 = Color(0xFFA5F3FC);
  static const Color physics300 = Color(0xFF67E8F9);
  static const Color physics400 = Color(0xFF22D3EE);
  static const Color physics500 = Color(0xFF06B6D4);
  static const Color physics600 = Color(0xFF0891B2);
  static const Color physics700 = Color(0xFF0E7490);
  static const Color physics800 = Color(0xFF155E75);
  static const Color physics900 = Color(0xFF164E63);
  static const Color physics950 = Color(0xFF083344);

  static const Color yellowgreen50 = Color(0xFFF5FAF4);
  static const Color yellowgreen100 = Color(0xFFE8F7E4);
  static const Color yellowgreen200 = Color(0xFFCEECC5);
  static const Color yellowgreen300 = Color(0xFFACDE9F);
  static const Color yellowgreen400 = Color(0xFF8AD077);
  static const Color yellowgreen500 = Color(0xFF66C149);
  static const Color yellowgreen600 = Color(0xFF53A23A);
  static const Color yellowgreen700 = Color(0xFF468333);
  static const Color yellowgreen800 = Color(0xFF366D25);
  static const Color yellowgreen900 = Color(0xFF1F4512);
  static const Color yellowgreen950 = Color(0xFF132B0C);

  static const Color red50 = Color(0xFFFFF6F4);
  static const Color red100 = Color(0xFFFFE4DF);
  static const Color red200 = Color(0xFFFFC7BC);
  static const Color red300 = Color(0xFFFDA293);
  static const Color red400 = Color(0xFFF47C6B);
  static const Color red500 = Color(0xFFEC5542);
  static const Color red600 = Color(0xFFC84435);
  static const Color red700 = Color(0xFFA1392C);
  static const Color red800 = Color(0xFF853025);
  static const Color red900 = Color(0xFF581C15);
  static const Color red950 = Color(0xFF370C07);

  static Color get skyblue50 => _currentByTheme(
        physics: physics50,
        chemistry: red50,
        biology: yellowgreen50,
      );
  static Color get skyblue100 => _currentByTheme(
        physics: physics100,
        chemistry: red100,
        biology: yellowgreen100,
      );
  static Color get skyblue200 => _currentByTheme(
        physics: physics200,
        chemistry: red200,
        biology: yellowgreen200,
      );
  static Color get skyblue300 => _currentByTheme(
        physics: physics300,
        chemistry: red300,
        biology: yellowgreen300,
      );
  static Color get skyblue400 => _currentByTheme(
        physics: physics400,
        chemistry: red400,
        biology: yellowgreen400,
      );
  static Color get skyblue500 => _currentByTheme(
        physics: physics500,
        chemistry: red500,
        biology: yellowgreen500,
      );
  static Color get skyblue600 => _currentByTheme(
        physics: physics600,
        chemistry: red600,
        biology: yellowgreen600,
      );
  static Color get skyblue700 => _currentByTheme(
        physics: physics700,
        chemistry: red700,
        biology: yellowgreen700,
      );
  static Color get skyblue800 => _currentByTheme(
        physics: physics800,
        chemistry: red800,
        biology: yellowgreen800,
      );
  static Color get skyblue900 => _currentByTheme(
        physics: physics900,
        chemistry: red900,
        biology: yellowgreen900,
      );
  static Color get skyblue950 => _currentByTheme(
        physics: physics950,
        chemistry: red950,
        biology: yellowgreen950,
      );

  static Color subject100(String? subjectName) => _fixedBySubjectName(
        subjectName: subjectName,
        physics: physics100,
        chemistry: red100,
        biology: yellowgreen100,
      );

  static Color subject500(String? subjectName) => _fixedBySubjectName(
        subjectName: subjectName,
        physics: physics500,
        chemistry: red500,
        biology: yellowgreen500,
      );

  static Color subject600(String? subjectName) => _fixedBySubjectName(
        subjectName: subjectName,
        physics: physics600,
        chemistry: red600,
        biology: yellowgreen600,
      );

  static Color subject700(String? subjectName) => _fixedBySubjectName(
        subjectName: subjectName,
        physics: physics700,
        chemistry: red700,
        biology: yellowgreen700,
      );

  static const Color hurricane50 = Color(0xfff3f3f3);
  static const Color hurricane100 = Color(0xffe2dfdf);
  static const Color hurricane200 = Color(0xffc6c3c2);
  static const Color hurricane300 = Color(0xffa69e9e);
  static const Color hurricane400 = Color(0xff8c8383);
  static const Color hurricane500 = Color(0xff7f7676);
  static const Color hurricane600 = Color(0xff6b6364);
  static const Color hurricane700 = Color(0xff575152);
  static const Color hurricane800 = Color(0xff4c4748);
  static const Color hurricane900 = Color(0xff434041);
  static const Color hurricane950 = Color(0xff252324);

  static final Color border = Color(0xff4A4A4A).withValues(alpha: 0.3);
  static final Color hintText = Color(0xff424242).withValues(alpha: 0.3);
  static final Color inputIcon = Color(0xff2A2A2D).withValues(alpha: 0.6);
  static final Color unselect = Color(0xff999999);
  static final Color backgroundTab = Color(0xff7F7676).withValues(alpha: 0.12);
  static final Color notComplete = Color(0xffFFCC00);
  static final Color completed = Color(0xff34C759);
  static final Color waitting = Color(0xff007AFF);

  static Color _currentByTheme({
    required Color physics,
    required Color chemistry,
    required Color biology,
  }) {
    return _colorByTheme(
      theme: _activeTheme,
      physics: physics,
      chemistry: chemistry,
      biology: biology,
    );
  }

  static Color _fixedBySubjectName({
    required String? subjectName,
    required Color physics,
    required Color chemistry,
    required Color biology,
  }) {
    final resolvedTheme = SubjectThemeHelper.resolveTheme(subjectName);
    return _colorByTheme(
      theme: resolvedTheme,
      physics: physics,
      chemistry: chemistry,
      biology: biology,
    );
  }

  static Color _colorByTheme({
    required SubjectThemeType theme,
    required Color physics,
    required Color chemistry,
    required Color biology,
  }) {
    return switch (theme) {
      SubjectThemeType.physics => physics,
      SubjectThemeType.chemistry => chemistry,
      SubjectThemeType.biology => biology,
    };
  }
}
