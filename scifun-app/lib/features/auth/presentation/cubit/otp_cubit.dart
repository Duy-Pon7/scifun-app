import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/auth/domain/usecases/verification_otp.dart';
import 'package:sci_fun/features/auth/presentation/cubit/otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  Timer? _countdownTimer;
  int _remainingTimer = 60;
  VerificationOtp verificationOtp;

  OtpCubit(this.verificationOtp) : super(OtpInitial());

  void startCountdown() {
    _remainingTimer = 60;

    emit(OtpCountdownState(_remainingTimer, false));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingTimer > 0) {
          _remainingTimer--;
          emit(OtpCountdownState(_remainingTimer, false));
        } else {
          _countdownTimer?.cancel();
          emit(OtpCountdownState(0, true));
        }
      },
    );
  }

  Future<void> resendOtp() async {
    try {
      emit(OtpResendSuccess());
      startCountdown();
    } catch (e) {
      emit(OtpResendError("Không thể gửi lại mã OTP. Vui lòng thử lại."));
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final result = await verificationOtp(VerificationOtpParams(
      email: email,
      otp: otp,
    ));
    result.fold(
      (failure) => emit(OtpFailure(failure.message)),
      (message) => emit(OtpSuccess()),
    );
  }
  // Future<void> verifyOtp(String otp) async {
  //   try {

  //     if (otp.contains("11111")) {
  //       emit(OtpSuccess());
  //     } else {
  //       emit(OtpFailure("Mã OTP không đúng. Vui lòng thử lại."));
  //     }
  //   } catch (e) {
  //     emit(OtpFailure("Mã OTP không đúng. Vui lòng thử lại."));
  //   }
  // }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
