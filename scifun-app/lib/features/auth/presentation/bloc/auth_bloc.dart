import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/usecases/change_password.dart';
import 'package:sci_fun/features/auth/domain/usecases/check_email_phone.dart';
import 'package:sci_fun/features/auth/domain/usecases/get_auth.dart';
import 'package:sci_fun/features/auth/domain/usecases/login.dart';
import 'package:sci_fun/features/auth/domain/usecases/resend_otp.dart';
import 'package:sci_fun/features/auth/domain/usecases/send_email.dart';
import 'package:sci_fun/features/auth/domain/usecases/forgot_password.dart';
import 'package:sci_fun/features/auth/domain/usecases/signup.dart';
import 'package:sci_fun/features/auth/domain/usecases/verification_otp.dart';
import 'package:sci_fun/features/auth/domain/usecases/reset_password.dart';

import '../../../../common/entities/user_entity.dart';
import '../../../../common/entities/user_check_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Signup _signup;
  final SendEmail _sendEmail;
  final ForgotPassword _forgotPassword;
  final GetAuth _getAuth;
  final ChangePassword _changPass;
  final CheckEmailPhone _checkEmailPhone;
  final ResendOtp _resendOtp;
  final VerificationOtp _verificationOtp;
  final ResetPassword _resetPassword;
  AuthBloc({
    required Login login,
    required Signup signup,
    required SendEmail sendEmail,
    required ForgotPassword forgotPassword,
    required GetAuth getAuth,
    required ChangePassword changPass,
    required CheckEmailPhone checkEmailPhone,
    required ResendOtp resendOtp,
    required VerificationOtp verificationOtp,
    required ResetPassword resetPassword,
  })  : _login = login,
        _signup = signup,
        _sendEmail = sendEmail,
        _forgotPassword = forgotPassword,
        _getAuth = getAuth,
        _changPass = changPass,
        _checkEmailPhone = checkEmailPhone,
        _resendOtp = resendOtp,
        _verificationOtp = verificationOtp,
        _resetPassword = resetPassword,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthLogin>(_onAuthLogin);
    on<AuthSignup>(_onAuthSignup);
    on<AuthSendEmail>(_onAuthSendEmail);
    on<AuthSendResetEmail>(_onAuthSendResetEmail);
    on<AuthGetSession>(_onAuthGetSession);
    on<AuthUpdateSession>(_onAuthUpdateSession);
    on<AuthChangePass>(_onChangePass);
    on<AuthCheckEmailPhone>(_onAuthCheckEmailPhone);
    on<AuthResendOtp>(_onAuthResendOtp);
    on<AuthVerificationOtp>(_onAuthVerificationOtp);
    on<AuthResetPassword>(_onAuthResetPassword);
  }

  void _onAuthSendResetEmail(
      AuthSendResetEmail event, Emitter<AuthState> emit) async {
    final res = await _forgotPassword.call(event.email);
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (message) async => emit(AuthMessageSuccess(message: message)));
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
        fullname: event.fullname,
        email: event.email));
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (user) => emit(AuthUserSuccess(user: user)));
  }

  void _onAuthSendEmail(AuthSendEmail event, Emitter<AuthState> emit) async {
    final res = await _sendEmail.call(event.email);
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (message) => emit(AuthMessageSuccess(message: message)));
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

  void _onAuthResetPassword(
      AuthResetPassword event, Emitter<AuthState> emit) async {
    final res = await _resetPassword.call(ResetPasswordParams(
      email: event.email,
      newPassword: event.newPass,
    ));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (message) async => emit(AuthUserSuccess(user: null)),
    );
  }

  void _onAuthCheckEmailPhone(
      AuthCheckEmailPhone event, Emitter<AuthState> emit) async {
    final res = await _checkEmailPhone.call(CheckEmailPhoneParams(
      phone: event.phone,
      email: event.email,
    ));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (userCheck) async => emit(AuthCheckEmailSuccess(userCheck: userCheck)),
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
