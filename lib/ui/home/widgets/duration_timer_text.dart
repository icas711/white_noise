import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/time_provider.dart';
import 'package:white_noise/services/extension.dart';

class DurationTimerText extends ConsumerWidget {
  const DurationTimerText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countDown = ref.watch(countDownControllerProvider);

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: (countDown.inSeconds == 0)
              ? Text(AppLocalizations.of(context)!.timer_disabled,
                  style: const TextStyle(fontSize: 16, color: Colors.white))
              : (countDown.inSeconds > 99999)
                  ? Text(AppLocalizations.of(context)!.timer_infinity,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white))
                  : Text(
                      '${AppLocalizations.of(context)!.timer} ${countDown.format()}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }
}
