import 'package:sci_fun/common/cubit/paginator_cubit.dart';
import 'package:sci_fun/features/exam/data/model/examset_model.dart';
import 'package:sci_fun/features/exam/domain/usecase/get_examset.dart';

class ExamsetPaginatorCubit extends PaginatorCubit<ExamsetModel, void> {
  ExamsetPaginatorCubit(GetExamset usecase)
      : super(usecase: usecase, limit: 10);
}
