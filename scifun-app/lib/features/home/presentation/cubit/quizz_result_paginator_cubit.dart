import 'package:thilop10_3004/common/cubit/paginator_cubit.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_result_entity.dart';
import 'package:thilop10_3004/features/home/domain/usecase/get_quizz_result.dart';

class QuizzResultPaginatorCubit
    extends PaginatorCubit<QuizzResultEntity, PaginationParamId<void>> {
  final int quizzId;

  QuizzResultPaginatorCubit({
    required GetQuizzResult usecase,
    required this.quizzId,
  }) : super(usecase: usecase, limit: 10);

  void fetchFirstPage() {
    paginateData(param: PaginationParamId<void>(page: 1, id: quizzId));
  }
}
