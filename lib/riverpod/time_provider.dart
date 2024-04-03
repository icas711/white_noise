import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/ui/home/widgets/mix_switch.dart';

final timeToEnd = StateProvider((ref) => 11);

final countDownControllerProvider =
    StateNotifierProvider.autoDispose<CountdownController, Duration>((ref) {
  return CountdownController(ref);
});

class CountdownController extends StateNotifier<Duration> {
  Timer? timer;
  var ref;
bool? _isStarted;

  CountdownController(this.ref) : super(const Duration(seconds: 3600));

  void startTimer() {
    _isStarted=true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == Duration.zero) {
        ref.read(audioPlayerProvider.notifier).stopAll();
        ref.read(switchProvider.notifier).update((state) => false);
        ref.read(countDownControllerProvider.notifier).addTime(duration: 3600);
        ref.read(fabImage.notifier).update((state) => 'reminder');
        timer?.cancel();
      } else {
        if (mounted) {
          state = state - const Duration(seconds: 1);
        } else {
          _isStarted=false;
          timer.cancel();
        }
      }
    });
  }

  void stopTimer() {
    _isStarted=false;
    timer?.cancel();
  }

  bool isStarted(){
    return _isStarted?? false;
  }
  void resetTimer({required Duration initialDuration}) {
    stopTimer();
    state = initialDuration;
    startTimer();
  }

  void addTime({required int duration}) {
    state = Duration(seconds: duration);
  }

  void subtractTime({required Duration duration}) {
    state = state - duration;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
