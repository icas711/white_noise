import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/ui/home/widgets/slider_volume.dart';

final volumeProvider = FutureProvider<List<Stream<double>>>((ref) async {
  final value = await ref.watch(audioPlayerProvider.notifier).volumeStream();
  return value;
});

class VolumeButton extends ConsumerWidget {
  const VolumeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = ref.watch(volumeProvider);
    return volume.when(
        data: (data) {
          return Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: [
                Text('${AppLocalizations.of(context)!.volume}: ',
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal.shade900),
                  ),
                  icon: const Icon(Icons.volume_up),
                  onPressed: () async {
                    await showSliderDialog(
                      context: context,
                      divisions: 10,
                      min: 0.0,
                      max: 1.0,
                      //value: data,
                      stream1: data[0],
                      stream2: data[1],
                      onChanged1:
                          ref.read(audioPlayerProvider.notifier).setVolume1,
                      onChanged2:
                          ref.read(audioPlayerProvider.notifier).setVolume2,
                    );
                  },
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return const CircularProgressIndicator();
        },
        loading: () => const CircularProgressIndicator());
  }

  Future<void> showSliderDialog({
    required BuildContext context,
    required int divisions,
    required double min,
    required double max,
    required Stream<double> stream1,
    required Stream<double> stream2,
    required ValueChanged<double> onChanged1,
    required ValueChanged<double> onChanged2,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        //title: Text(AppLocalizations.of(context)!.volume, textAlign: TextAlign.center),
        content: SizedBox(
          height: 220,
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.general_volume),
              SliderVolume(),
              StreamBuilder<double>(
                  stream: stream1,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Text(AppLocalizations.of(context)!.channel1),
                        Slider(
                          //divisions: divisions,
                          min: min,
                          max: max,
                          value: snapshot.data ?? 0,
                          onChanged: onChanged1,
                        ),
                      ],
                    );
                  }),
              StreamBuilder<double>(
                  stream: stream2,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Text(AppLocalizations.of(context)!.channel2),
                        Slider(
                          //divisions: divisions,
                          min: min,
                          max: max,
                          value: snapshot.data ?? 0,
                          onChanged: onChanged2,
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),

        actions: [
          Center(
            child: CupertinoButton(
              color: CupertinoColors.white.withOpacity(0.7),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // dismisses only the dialog and returns nothing
              },
              child: Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
