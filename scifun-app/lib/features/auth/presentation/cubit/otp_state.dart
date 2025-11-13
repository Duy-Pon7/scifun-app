import 'package:equatable/equatable.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

final class OtpInitial extends OtpState {}

class OtpCountdownState extends OtpState {
  final int remainingTime;
  final bool canResend;

  const OtpCountdownState(this.remainingTime, this.canResend);

  @override
  List<Object> get props => [remainingTime, canResend];
}

final class OtpSuccess extends OtpState {}

final class OtpFailure extends OtpState {
  final String message;
  
  const OtpFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class OtpResendSuccess extends OtpState {}

final class OtpResendError extends OtpState {
  final String message;
  
  const OtpResendError(this.message);

  @override
  List<Object> get props => [message];
}
