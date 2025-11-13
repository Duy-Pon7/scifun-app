import 'package:flutter_bloc/flutter_bloc.dart';

class CheckedCubit extends Cubit<bool> {
  CheckedCubit() : super(false);

  void toggleCheckStatus(bool? newVal) => emit(newVal ?? state);
}
