import 'package:thilop10_3004/common/cubit/paginator_cubit.dart';
import 'package:thilop10_3004/features/exam/data/model/examset_model.dart';
import 'package:thilop10_3004/features/exam/domain/usecase/get_examset.dart';

class ExamsetPaginatorCubit extends PaginatorCubit<ExamsetModel, void> {
  ExamsetPaginatorCubit(GetExamset usecase)
      : super(usecase: usecase, limit: 10);
}
