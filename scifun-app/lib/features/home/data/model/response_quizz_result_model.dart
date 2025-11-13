import 'package:sci_fun/features/home/data/model/quizz_result_model.dart';
import 'package:sci_fun/features/home/domain/entity/response_quizz_result_entity.dart';

class ResponseQuizzResultModel extends ResponseQuizzResultEntity {
  ResponseQuizzResultModel({required super.quizzes});

  factory ResponseQuizzResultModel.fromJson(Map<String, dynamic> json) {
    return ResponseQuizzResultModel(
      quizzes: QuizzResultModel.fromListJson(json["quiz_results"]), // ✅ đúng
    );
  }
}
