import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTabCubit extends Cubit<int>{
  SelectTabCubit() : super(0);

  void selectTab(int index) => emit(index);
}