import 'package:sci_fun/features/analytics/domain/entities/school_data_entity.dart';

class SchoolDataModel extends SchoolDataEntity {
  SchoolDataModel({
    required super.schoolCode,
    required super.schoolName,
    required super.province,
    required super.firstChoice,
    required super.secondChoice,
    required super.thirdChoice,
    required super.year,
  });

  factory SchoolDataModel.fromJson(Map<String, dynamic> json) {
    return SchoolDataModel(
      schoolCode: json["school_code"],
      schoolName: json["school_name"],
      province: json["province"],
      firstChoice: json["first_choice"],
      secondChoice: json["second_choice"],
      thirdChoice: json["third_choice"],
      year: json["year"],
    );
  }
}
