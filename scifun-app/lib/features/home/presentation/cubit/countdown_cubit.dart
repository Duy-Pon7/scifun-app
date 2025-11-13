import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class CountdownState {
  final int remainingSecond;
  final int totalSeconds;

  CountdownState({required this.remainingSecond, required this.totalSeconds});

  double get progress => remainingSecond / totalSeconds;

  int get timeTaken => totalSeconds - remainingSecond;
}

class CountdownCubit extends Cubit<CountdownState> {
  Timer? _timer;

  CountdownCubit({required int totalSeconds})
      : super(CountdownState(
            remainingSecond: totalSeconds, totalSeconds: totalSeconds)) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.remainingSecond > 0) {
          emit(
            CountdownState(
              remainingSecond: state.remainingSecond - 1,
              totalSeconds: state.totalSeconds,
            ),
          );
        } else {
          timer.cancel();
        }
      },
    );
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String getFormattedTimeTaken() {
    final timeTaken = state.timeTaken;
    final minutes = timeTaken ~/ 60;
    final seconds = timeTaken % 60;
    return "${minutes.toString().padLeft(2, '0')}'${seconds.toString().padLeft(2, '0')}\"";
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _timer?.cancel();
    return super.close();
  }
}
