class SchoolScoresEntity {
  SchoolScoresEntity({
    required this.userScores,
    required this.suggestedSchools,
    required this.year,
  });

  final UserScoresEntity? userScores;
  final List<SuggestedSchoolEntity> suggestedSchools;
  final String? year;
}

class SuggestedSchoolEntity {
  SuggestedSchoolEntity({
    required this.school,
    required this.year,
    required this.recommendations,
    required this.note,
  });

  final SchoolEntity? school;
  final int? year;
  final List<RecommendationEntity> recommendations;
  final String? note;
}

class RecommendationEntity {
  RecommendationEntity({
    required this.choice,
    required this.choiceName,
    required this.requiredScore,
    required this.difference,
    required this.probability,
  });

  final String? choice;
  final String? choiceName;
  final String? requiredScore;
  final int? difference;
  final String? probability;
}

class SchoolEntity {
  SchoolEntity({
    required this.code,
    required this.name,
  });

  final String? code;
  final String? name;
}

class UserScoresEntity {
  UserScoresEntity({
    required this.mathematics,
    required this.foreignLanguage,
    required this.literature,
    required this.totalScore,
  });

  final ForeignLanguageEntity? mathematics;
  final ForeignLanguageEntity? foreignLanguage;
  final ForeignLanguageEntity? literature;
  final int? totalScore;
}

class ForeignLanguageEntity {
  ForeignLanguageEntity({
    required this.subject,
    required this.latestScore,
  });

  final SubjectEntity? subject;
  final int? latestScore;
}

class SubjectEntity {
  SubjectEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.type,
  });

  final int? id;
  final String? name;
  final String? avatar;
  final String? type;
}
