// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sci_fun/common/entities/user_entity.dart';
// import 'package:sci_fun/features/profile/domain/usecase/change_user.dart';
// part 'user_event.dart';
// part 'user_state.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final Changes _change;

//   UserBloc({
//     required Changes change,
//   })  : _change = change,
//         super(UserInitial()) {
//     on<ChangeUser>(_onChangeUser);
//   }

//   void _onChangeUser(
//       ChangeUser event, Emitter<UserState> emit) async {
//     final res = await _change.call(ChangeUserParams(
//       fullname: event.fullname,
//       email: event.email,
//       birthday: event.birthday,
//       gender: event.gender,
//       image: event.image,
//       provinceId: event.provinceId,
//       wardId: event.wardId,
//     ));
//     print("ChangeUser: ${event.fullname}, ${event.image}");
//     res.fold(
//       (failure) => emit(UserFailure(message: failure.message)),
//       (user) => emit(UserSuccess(user: user)),
//     );
//   }
// }
