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

  UserUpdated(super.user, {DateTime? updatedAt})
      : updatedAt = updatedAt ?? DateTime.now();

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
    print('UserCubit.getUser: token=$token');
    _tryEmit(UserLoading());
    try {
      final res = await getInfoUser.call(token: token);
      return await res.fold(
        (failure) {
          print('UserCubit.getUser failure: ${failure.message}');
          _tryEmit(UserError(failure.message));
          return null;
        },
        (data) {
          final user = data!;
          print(
              'UserCubit.getUser success: id=${user.data?.id} fullname=${user.data?.fullname}');
          _tryEmit(UserLoaded(user));
          return user;
        },
      );
    } catch (e) {
      print('UserCubit.getUser exception: $e');
      _tryEmit(UserError(e.toString()));
      return null;
    }
  }

  Future<UserGetEntity?> _fetchUserSilent({required String userId}) async {
    try {
      final res = await getInfoUser.call(token: userId);
      return await res.fold((failure) => null, (data) => data);
    } catch (e) {
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
    // Capture previous state before emitting loading so we can fallback to it later
    final prevState = state;
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
        (returned) async {
          // If the update usecase returned the updated user entity, use it directly
          if (returned != null) {
            final updatedEntity = returned;
            final data = updatedEntity.data;
            final userGet = UserGetEntity(
              status: updatedEntity.status,
              message: updatedEntity.message,
              data: data == null
                  ? null
                  : UserDataEntity(
                      id: data.id,
                      email: data.email,
                      fullname: data.fullname,
                      avatar: data.avatar,
                      sex: data.sex,
                      dob: data.dob,
                      role: data.role,
                      subscription: data.subscription == null
                          ? null
                          : SubscriptionEntity(
                              status: data.subscription!.status,
                              tier: data.subscription!.tier,
                              currentPeriodEnd:
                                  data.subscription!.currentPeriodEnd,
                              provider: data.subscription!.provider,
                            ),
                    ),
            );
            _tryEmit(UserUpdated(userGet));
            return;
          }

          // Otherwise try a silent refresh and fallback to previous state as before
          final user = await _fetchUserSilent(userId: userId);
          if (user != null) {
            _tryEmit(UserUpdated(user));
          } else {
            if (prevState is UserLoaded) {
              final prevUser = prevState.user;
              final updatedData = prevUser.data?.copyWith(
                fullname: fullname,
                sex: sex,
                dob: dob,
              );
              final updatedUser = prevUser.copyWith(data: updatedData);
              _tryEmit(UserUpdated(updatedUser));
            } else {
              final fallback = UserGetEntity(
                status: 200,
                message: 'Cập nhật thành công',
                data: null,
              );
              _tryEmit(UserUpdated(fallback));
            }
          }
        },
      );
    } catch (e) {
      _tryEmit(UserError(e.toString()));
    }
  }

  /// Clear current user state (used on logout)
  void clear() {
    _tryEmit(UserInitial());
  }
}
