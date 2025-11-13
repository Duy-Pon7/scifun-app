import 'package:sci_fun/features/home/data/model/quizz_model.dart';
import 'package:sci_fun/features/home/domain/entity/response_quizz_entity.dart';

class ResponseQuizzModel extends ResponseQuizzEntity {
  ResponseQuizzModel({required super.quizzes});

  factory ResponseQuizzModel.fromJson(Map<String, dynamic> json) {
    return ResponseQuizzModel(
      quizzes: QuizzModel.fromListJson(json["quizzes"]), // ✅ đúng
    );
  }
}
