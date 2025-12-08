import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/features/question/domain/usecase/get_all_question.dart';

class QuestionCubit extends PaginationCubit<QuestionEntity> {
  final GetAllQuestions getAllQuestions;

  QuestionCubit(this.getAllQuestions);

  @override
  Future<List<QuestionEntity>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    // filterId chứa topicId
    if (filterId == null) {
      throw Exception('Topic ID is required');
    }

    final result = await getAllQuestions(
      QuestionsParams(
        quizId: filterId,
        page: page,
        limit: limit,
      ),
    );

    return result.fold(
      (failure) => throw Exception(failure.message), // Handle error
      (questionEntity) => questionEntity.data, // Return list of questions
    );
  }
}
