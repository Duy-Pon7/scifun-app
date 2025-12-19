import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedSubjectCubit extends Cubit<String?> {
  SelectedSubjectCubit() : super(null);

  void selectSubject(String subjectId) {
    emit(subjectId);
  }
}
