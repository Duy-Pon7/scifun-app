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
  String? _loadedToken;
  String? _pendingToken;
  Future<UserGetEntity?>? _pendingRequest;
  int _requestNonce = 0;

  UserCubit({
    required this.getInfoUser,
    required this.updateInfoUser,
  }) : super(UserInitial());

  void _tryEmit(UserState state) {
    if (!isClosed) emit(state);
  }

  Future<UserGetEntity?> getUser({
    required String token,
    bool forceRefresh = false,
  }) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return null;
    }

    if (_pendingRequest != null && _pendingToken == normalizedToken) {
      return _pendingRequest!;
    }

    final currentState = state;
    if (!forceRefresh &&
        currentState is UserLoaded &&
        _loadedToken == normalizedToken) {
      return currentState.user;
    }

    final requestNonce = ++_requestNonce;
    final request = _fetchUser(
      token: normalizedToken,
      requestNonce: requestNonce,
    );
    _pendingToken = normalizedToken;
    _pendingRequest = request;

    final user = await request;

    if (identical(_pendingRequest, request)) {
      _pendingRequest = null;
      _pendingToken = null;
      if (user != null) {
        _loadedToken = normalizedToken;
      }
    }

    return user;
  }

  Future<UserGetEntity?> _fetchUser({
    required String token,
    required int requestNonce,
  }) async {
    _tryEmit(UserLoading());
    try {
      final res = await getInfoUser.call(token: token);
      return await res.fold(
        (failure) {
          if (requestNonce != _requestNonce) {
            return null;
          }
          _tryEmit(UserError(failure.message));
          return null;
        },
        (data) {
          final user = data!;
          if (requestNonce != _requestNonce) {
            return user;
          }
          _tryEmit(UserLoaded(user));
          return user;
        },
      );
    } catch (e) {
      if (requestNonce != _requestNonce) {
        return null;
      }
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
    required String level,
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
        level: level,
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
            final currentState = state;
            int? currentDaysRemaining;
            bool? currentIsGuest;
            if (currentState is UserLoaded) {
              currentDaysRemaining = currentState.user.data?.daysRemaining;
              currentIsGuest = currentState.user.data?.isGuest;
            }

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
                isGuest: currentIsGuest,
                daysRemaining: currentDaysRemaining,
                level: returned.data!.level,
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
    _loadedToken = null;
    _pendingToken = null;
    _pendingRequest = null;
    _requestNonce++;
    _tryEmit(UserInitial());
  }
}
