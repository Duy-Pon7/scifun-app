import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/entities/user_check_entity.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/usecases/change_password.dart';
import 'package:sci_fun/features/auth/domain/usecases/check_email_phone.dart';
import 'package:sci_fun/features/auth/domain/usecases/get_auth.dart';
import 'package:sci_fun/features/auth/domain/usecases/login.dart';
import 'package:sci_fun/features/auth/domain/usecases/resend_otp.dart';
import 'package:sci_fun/features/auth/domain/usecases/reset_password.dart';
import 'package:sci_fun/features/auth/domain/usecases/send_email.dart';
import 'package:sci_fun/features/auth/domain/usecases/signup.dart';
import 'package:sci_fun/features/auth/domain/usecases/verification_otp.dart';
import 'package:sci_fun/features/auth/domain/usecases/verify_otp.dart';
import 'package:sci_fun/features/profile/domain/usecase/change_user.dart';

import '../../../../common/entities/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Signup _signup;
  final SendEmail _sendEmail;
  final VerifyOtp _verifyOtp;
  final ResetPassword _resetPassword;
  final GetAuth _getAuth;
  final ChangePassword _changPass;
  final CheckEmailPhone _checkEmailPhone;
  final ResendOtp _resendOtp;
  final VerificationOtp _verificationOtp;
  AuthBloc({
    required Login login,
    required Signup signup,
    required SendEmail sendEmail,
    required VerifyOtp verifyOtp,
    required ResetPassword resetPassword,
    required GetAuth getAuth,
    required ChangePassword changPass,
    required CheckEmailPhone checkEmailPhone,
    required ResendOtp resendOtp,
    required VerificationOtp verificationOtp,
  })  : _login = login,
        _signup = signup,
        _sendEmail = sendEmail,
        _verifyOtp = verifyOtp,
        _resetPassword = resetPassword,
        _checkEmailPhone = checkEmailPhone,
        _getAuth = getAuth,
        _changPass = changPass,
        _resendOtp = resendOtp,
        _verificationOtp = verificationOtp,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthLogin>(_onAuthLogin);
    on<AuthSignup>(_onAuthSignup);
    on<AuthSendEmail>(_onAuthSendEmail);
    on<AuthVerifyOtp>(_onAuthVerifyOtp);
    on<AuthResetPassword>(_onAuthResetPassword);
    on<AuthGetSession>(_onAuthGetSession);
    on<AuthUpdateSession>(_onAuthUpdateSession);
    on<AuthCheckEmailPhone>(_onCheckEmailPhone);
    on<AuthChangePass>(_onChangePass);
    on<AuthResendOtp>(_onAuthResendOtp);
    on<AuthVerificationOtp>(_onAuthVerificationOtp);
  }
  void _onAuthVerificationOtp(
      AuthVerificationOtp event, Emitter<AuthState> emit) async {
    final res = await _verificationOtp.call(VerificationOtpParams(
      email: event.email,
      otp: event.otp,
    ));
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (success) async => emit(AuthMessageSuccess(message: success)));
  }

  void _onAuthResendOtp(AuthResendOtp event, Emitter<AuthState> emit) async {
    final res = await _resendOtp.call(ResendOtpParams(
      email: event.email,
    ));
    res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (success) async =>
            emit(AuthMessageSuccess(message: success.toString())));
  }

  void _onCheckEmailPhone(
      AuthCheckEmailPhone event, Emitter<AuthState> emit) async {
    final res = await _checkEmailPhone.call(CheckEmailPhoneParams(
      phone: event.phone,
      email: event.email,
    ));
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (usercheck) async => emit(AuthCheckSuccess(usercheck: usercheck)));
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _login.call(LoginParams(
      email: event.email,
      password: event.password,
    ));
    res.fold(
      (failure) {
        print("❌ Login failure: ${failure.message}");
        emit(AuthFailure(message: failure.message));
      },
      (user) async {
        print("✅ Login success: $user");
        emit(AuthUserLoginSuccess(user: user));
      },
    );
  }

  void _onAuthSignup(AuthSignup event, Emitter<AuthState> emit) async {
    final res = await _signup.call(SignupParams(
        password: event.password,
        passwordConfimation: event.passwordConfimation,
        phone: event.phone,
        fullname: event.fullname,
        provinceId: event.provinceId,
        wardId: event.wardId,
        email: event.email,
        birthday: event.birthday));
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (user) => emit(AuthUserSuccess(user: user)));
  }

  void _onAuthSendEmail(AuthSendEmail event, Emitter<AuthState> emit) async {
    final res = await _sendEmail.call(event.email);
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (message) => emit(AuthMessageSuccess(message: message)));
  }

  void _onAuthVerifyOtp(AuthVerifyOtp event, Emitter<AuthState> emit) async {
    final res = await _verifyOtp.call(VerifyOtpParams(
      email: event.email,
      otp: event.otp,
    ));
    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (message) => emit(AuthSuccess()),
    );
  }

  void _onAuthResetPassword(
      AuthResetPassword event, Emitter<AuthState> emit) async {
    final res = await _resetPassword.call(ResetPasswordParams(
      email: event.email,
      newPass: event.newPass,
      newPassConfirm: event.newPassConfirm,
    ));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthUserSuccess(user: user)),
    );
  }

  void _onChangePass(AuthChangePass event, Emitter<AuthState> emit) async {
    final res = await _changPass.call(ChangePasswordParams(
      oldPass: event.oldPass,
      newPass: event.newPass,
      newPassConfirm: event.newPassConfirm,
    ));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (message) => emit(AuthMessageSuccess(message: message)),
    );
  }

  void _onAuthGetSession(AuthGetSession event, Emitter<AuthState> emit) async {
    final res = await _getAuth.call(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthUserSuccess(user: user)),
    );
  }

  void _onAuthUpdateSession(AuthUpdateSession event, Emitter<AuthState> emit) {
    emit(AuthUserSuccess(user: event.user));
  }
}
