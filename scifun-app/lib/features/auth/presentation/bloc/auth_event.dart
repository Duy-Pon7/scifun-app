part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthSignup extends AuthEvent {
  final String password;
  final String passwordConfimation;
  final String phone;
  final String fullname;
  final int provinceId;
  final int wardId;
  final DateTime birthday;
  final String email;

  AuthSignup(
      {required this.password,
      required this.passwordConfimation,
      required this.phone,
      required this.fullname,
      required this.provinceId,
      required this.wardId,
      required this.email,
      required this.birthday});
}

final class AuthSendEmail extends AuthEvent {
  final String email;

  AuthSendEmail({required this.email});
}

final class AuthSendResetEmail extends AuthInitial {
  final String email;

  AuthSendResetEmail({required this.email});
}

final class AuthVerifyOtp extends AuthEvent {
  final String email;
  final String otp;

  AuthVerifyOtp({required this.email, required this.otp});
}

final class AuthResetPassword extends AuthEvent {
  final String email;
  final String newPass;
  final String newPassConfirm;

  AuthResetPassword({
    required this.email,
    required this.newPass,
    required this.newPassConfirm,
  });
}

final class AuthChangePass extends AuthEvent {
  final String oldPass;
  final String newPass;
  final String newPassConfirm;

  AuthChangePass({
    required this.oldPass,
    required this.newPass,
    required this.newPassConfirm,
  });
}

class AuthResendOtp extends AuthEvent {
  final String email;
  AuthResendOtp({required this.email});
}

class AuthVerificationOtp extends AuthEvent {
  final String email;
  final String otp;
  AuthVerificationOtp({required this.email, required this.otp});
}

final class AuthCheckEmailPhone extends AuthEvent {
  final String phone;
  final String email;

  AuthCheckEmailPhone({required this.phone, required this.email});
}

final class AuthGetSession extends AuthEvent {}

final class AuthUpdateSession extends AuthEvent {
  final UserEntity? user;

  AuthUpdateSession({this.user});
}

final class ChangeUser extends AuthEvent {
  final String fullname;
  final String email;
  final int gender;
  final DateTime birthday;
  final File? image;
  final int provinceId;
  final int wardId;

  ChangeUser(
      {required this.fullname,
      required this.email,
      required this.gender,
      required this.birthday,
      required this.provinceId,
      required this.wardId,
      this.image});
}
