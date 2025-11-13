import 'package:thilop10_3004/features/subject/data/model/subject_item_model.dart';
import 'package:thilop10_3004/features/subject/domain/entity/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  SubjectModel({required super.subjects});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjects: SubjectItemModel.fromListJson(json['subjects']),
    );
  }
}
