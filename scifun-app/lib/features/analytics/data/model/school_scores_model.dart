import 'package:thilop10_3004/features/analytics/domain/entities/school_scores_entity.dart';

class SchoolScoresModel extends SchoolScoresEntity {
  SchoolScoresModel({
    required super.userScores,
    required super.suggestedSchools,
    required super.year,
  });

  factory SchoolScoresModel.fromJson(Map<String, dynamic> json) {
    return SchoolScoresModel(
      userScores: json["user_scores"] == null
          ? null
          : UserScoresModel.fromJson(json["user_scores"]),
      suggestedSchools: json["suggested_schools"] == null
          ? []
          : List<SuggestedSchoolModel>.from(json["suggested_schools"]!
              .map((x) => SuggestedSchoolModel.fromJson(x))),
      year: json["year"],
    );
  }
}

class SuggestedSchoolModel extends SuggestedSchoolEntity {
  SuggestedSchoolModel({
    required super.school,
    required super.year,
    required super.recommendations,
    required super.note,
  });

  factory SuggestedSchoolModel.fromJson(Map<String, dynamic> json) {
    return SuggestedSchoolModel(
      school:
          json["school"] == null ? null : SchoolModel.fromJson(json["school"]),
      year: json["year"],
      recommendations: json["recommendations"] == null
          ? []
          : List<RecommendationModel>.from(json["recommendations"]!
              .map((x) => RecommendationModel.fromJson(x))),
      note: json["note"],
    );
  }
}

class RecommendationModel extends RecommendationEntity {
  RecommendationModel({
    required super.choice,
    required super.choiceName,
    required super.requiredScore,
    required super.difference,
    required super.probability,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      choice: json["choice"],
      choiceName: json["choice_name"],
      requiredScore: json["required_score"],
      difference: json["difference"],
      probability: json["probability"],
    );
  }
}

class SchoolModel extends SchoolEntity {
  SchoolModel({
    required super.code,
    required super.name,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      code: json["code"],
      name: json["name"],
    );
  }
}

class UserScoresModel extends UserScoresEntity {
  UserScoresModel({
    required super.mathematics,
    required super.foreignLanguage,
    required super.literature,
    required super.totalScore,
  });

  factory UserScoresModel.fromJson(Map<String, dynamic> json) {
    return UserScoresModel(
      mathematics: json["mathematics"] == null
          ? null
          : ForeignLanguageModel.fromJson(json["mathematics"]),
      foreignLanguage: json["foreign_language"] == null
          ? null
          : ForeignLanguageModel.fromJson(json["foreign_language"]),
      literature: json["literature"] == null
          ? null
          : ForeignLanguageModel.fromJson(json["literature"]),
      totalScore: json["total_score"],
    );
  }
}

class ForeignLanguageModel extends ForeignLanguageEntity {
  ForeignLanguageModel({
    required super.subject,
    required super.latestScore,
  });

  factory ForeignLanguageModel.fromJson(Map<String, dynamic> json) {
    return ForeignLanguageModel(
      subject: json["subject"] == null
          ? null
          : SubjectModel.fromJson(json["subject"]),
      latestScore: json["latest_score"],
    );
  }
}

class SubjectModel extends SubjectEntity {
  SubjectModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.type,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
      type: json["type"],
    );
  }
}
