import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCubit<T> extends Cubit<T> {
  SelectCubit(
      super.initialState); // SelectCubit(T initialState) : super(initialState);

  void select(T value) {
    emit(value);
  }
}
