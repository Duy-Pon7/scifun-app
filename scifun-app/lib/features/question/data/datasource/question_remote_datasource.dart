import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/question/data/model/question_model.dart';

abstract interface class QuestionRemoteDatasource {
  Future<QuestionsResponseModel> getAllQuestions({
    required String quizId,
    int page = 1,
    int limit = 10,
  });
}

class QuestionRemoteDatasourceImpl implements QuestionRemoteDatasource {
  final DioClient dioClient;

  QuestionRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<QuestionsResponseModel> getAllQuestions({
    required String quizId,
    int page = 1,
    int limit = 10,
  }) async {
    print(
        "Fetching questions for quizId: $quizId, page: $page, limit: $limit"); // Debug print
    try {
      final res = await dioClient.get(
        url:
            "${QuestionApiUrl.getQuestions}?page=$page&limit=$limit&quizId=$quizId",
      );
      print("Response Data 123: ${res.data}"); // Debug print
      if (res.statusCode == 200) {
        final responseData = res.data['data'];
        return QuestionsResponseModel.fromJson(responseData);
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print("Error fetching questions: $e"); // Debug print
      throw Exception('Failed to load questions: $e');
    }
  }
}
