
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/riverpod/time_provider.dart';

final switchProvider = StateProvider((ref) => false);

class MixSwitch extends ConsumerStatefulWidget {
  const MixSwitch({super.key});

  @override
  ConsumerState<MixSwitch> createState() => _MixSwitchState();
}

class _MixSwitchState extends ConsumerState<MixSwitch> {
  bool _lihgt = false;

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songsProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          AppLocalizations.of(context)!.mixlullaby,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Switch(
              value: ref.watch(switchProvider),
              onChanged: (value) async {
                final mix = checkMix();
                if (mix && !value) {
                  ref.read(countDownControllerProvider.notifier).stopTimer();
                }
                if (mix || !value) {

                  setState(() {
                    ref.read(switchProvider.notifier).update((state) => value);
                  });

                  await ref
                      .watch(audioPlayerProvider.notifier)
                      .startMix(songs, value);

                }
              }),
        ),
      ],
    );
  }

  bool checkMix() {
    final playing1 = ref.watch(audioPlayerProvider).playingFirst;
    final playing2 = ref.watch(audioPlayerProvider).playingSecond;
    if (playing1 && playing2) {
      return false;
    }
    return true;
  }
}
