class SchoolDataEntity {
  SchoolDataEntity({
    required this.schoolCode,
    required this.schoolName,
    required this.province,
    required this.firstChoice,
    required this.secondChoice,
    required this.thirdChoice,
    required this.year,
  });

  final String? schoolCode;
  final String? schoolName;
  final String? province;
  final int? firstChoice;
  final int? secondChoice;
  final int? thirdChoice;
  final int? year;
}
