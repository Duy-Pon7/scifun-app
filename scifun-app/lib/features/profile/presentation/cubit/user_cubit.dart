import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/entities/user_get_entity.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_info_user.dart';
import 'package:sci_fun/features/profile/domain/usecase/update_info_user.dart';

sealed class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserGetEntity user;
  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UserLoaded {
  final DateTime updatedAt;

  UserUpdated(UserGetEntity user, {DateTime? updatedAt})
      : updatedAt = updatedAt ?? DateTime.now(),
        super(user);

  @override
  List<Object?> get props => [user, updatedAt];
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

  void _tryEmit(UserState state) {
    if (!isClosed) emit(state);
  }

  Future<UserGetEntity?> getUser({required String token}) async {
    _tryEmit(UserLoading());
    try {
      final res = await getInfoUser.call(token: token);
      return await res.fold(
        (failure) {
          _tryEmit(UserError(failure.message));
          return null;
        },
        (data) {
          final user = data!;
          _tryEmit(UserLoaded(user));
          return user;
        },
      );
    } catch (e) {
      _tryEmit(UserError(e.toString()));
      return null;
    }
  }

  Future<void> updateUser({
    required String token,
    required String userId,
    required String fullname,
    required DateTime dob,
    required int sex,
    File? avatar,
  }) async {
    _tryEmit(UserLoading());
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
        (failure) => _tryEmit(UserError(failure.message)),
        (_) async {
          final user = await getUser(token: token);
          if (user != null) {
            _tryEmit(UserUpdated(user));
          }
        },
      );
    } catch (e) {
      _tryEmit(UserError(e.toString()));
    }
  }
}
