// Cubit
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/domain/repository/subject_repository.dart';

class SubjectCubit extends PaginationCubit<SubjectEntity> {
  final SubjectRepository repository;

  SubjectCubit(this.repository);

  @override
  Future<List<SubjectEntity>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    // Call the repository's getAllSubjects (which returns Either).
    // Pass the searchQuery parameter and convert the Either result.
    final result = await repository.getAllSubjects(searchQuery);

    // Convert Either<Failure, List<SubjectEntity>> into List<SubjectEntity>.
    // On failure return an empty list, on success return the list as-is.
    return result.fold((failure) => [], (subjects) => subjects);
  }
}
