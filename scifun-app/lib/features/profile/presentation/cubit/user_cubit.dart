import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_info_user.dart';
import 'package:sci_fun/features/profile/domain/usecase/update_info_user.dart';

sealed class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;
  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserCubit extends Cubit<UserState> {
  final GetInfoUser getInfoUser;
  final UpdateInfoUser updateInfoUser;

  UserCubit({
    required this.getInfoUser,
    required this.updateInfoUser,
  }) : super(UserInitial());

  Future<void> getUser({required String token}) async {
    emit(UserLoading());
    try {
      final res = await getInfoUser.call(token: token);
      res.fold(
        (failure) => emit(UserError(failure.message)),
        (data) => emit(UserLoaded(data!)),
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUser({
    required String userId,
    required String fullname,
    required DateTime dob,
    required int sex,
    File? avatar,
  }) async {
    emit(UserLoading());
    try {
      final params = UpdateInfoUserParams(
        userId: userId,
        fullname: fullname,
        dob: dob,
        sex: sex,
        avatar: avatar,
      );
      final res = await updateInfoUser.call(params);
      res.fold(
        (failure) => emit(UserError(failure.message)),
        (data) => emit(UserLoaded(data!)),
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
