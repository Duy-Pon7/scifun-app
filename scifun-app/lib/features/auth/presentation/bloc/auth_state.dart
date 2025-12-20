part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthInitial {}

final class AuthFailure extends AuthInitial {
  final String message;

  AuthFailure({required this.message});
}

final class AuthMessageSuccess extends AuthInitial {
  final String message;

  AuthMessageSuccess({required this.message});
}

final class AuthUserSuccess extends AuthInitial {
  final UserEntity? user;

  AuthUserSuccess({required this.user});
}

final class AuthUserLoginSuccess extends AuthInitial {
  final UserEntity? user;

  AuthUserLoginSuccess({required this.user});
}

final class AuthCheckEmailSuccess extends AuthInitial {
  final UserCheckEntity userCheck;

  AuthCheckEmailSuccess({required this.userCheck});
}

final class AuthSuccess extends AuthInitial {}
