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

  Future<void> updateUser({
    required String token,
    required String userId,
    required String fullname,
    required DateTime dob,
    required int sex,
    File? avatar,
  }) async {
    print('UserCubit.updateUser: userId=$userId, fullname=$fullname');
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
      print('UserCubit.updateUser: got response');

      res.fold(
        (failure) {
          print('UserCubit.updateUser failure: ${failure.message}');
          _tryEmit(UserError(failure.message));
        },
        (returned) {
          print('UserCubit.updateUser success: returned=$returned');
          // Nếu update thành công, dùng dữ liệu trả về từ API trực tiếp
          if (returned != null && returned.data != null) {
            // Convert UserModel data to UserGetEntity
            final updatedUser = UserGetEntity(
              status: returned.status,
              message: returned.message,
              data: UserDataEntity(
                id: returned.data!.id,
                email: returned.data!.email,
                fullname: returned.data!.fullname,
                avatar: returned.data!.avatar,
                sex: returned.data!.sex,
                dob: returned.data!.dob,
                role: returned.data!.role,
                subscription: returned.data!.subscription != null
                    ? SubscriptionEntity(
                        status: returned.data!.subscription!.status,
                        tier: returned.data!.subscription!.tier,
                        currentPeriodEnd:
                            returned.data!.subscription!.currentPeriodEnd,
                        provider: returned.data!.subscription!.provider,
                      )
                    : null,
              ),
            );
            print('UserCubit.updateUser: emitting UserUpdated');
            _tryEmit(UserUpdated(updatedUser));
            return;
          }

          // Fallback nếu không có dữ liệu trả về
          print('UserCubit.updateUser: no data returned');
          _tryEmit(UserError('Cập nhật thất bại: Không có dữ liệu trả về'));
        },
      );
    } catch (e) {
      print('UserCubit.updateUser exception: $e');
      _tryEmit(UserError('Lỗi: ${e.toString()}'));
    }
  }

  /// Clear current user state (used on logout)
  void clear() {
    _tryEmit(UserInitial());
  }
}
