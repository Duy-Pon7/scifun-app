import 'package:sci_fun/common/cubit_new/pagination_cubit.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/quizz/domain/usecase/get_all_quizz.dart';

class QuizzCubit extends PaginationCubit<QuizzEntity> {
  final GetAllQuizzes getAllQuizzes;

  QuizzCubit(this.getAllQuizzes);

  @override
  Future<List<QuizzEntity>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    final result = await getAllQuizzes.call(
      QuizzParams(
        searchQuery ?? "",
        topicId: filterId ?? "",
        page: page,
        limit: limit,
      ),
    );

    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (list) => list,
    );
  }
}
