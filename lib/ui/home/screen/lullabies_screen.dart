import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/ui/home/widgets/lullabies_sound_widget.dart';
import 'package:white_noise/ui/home/widgets/mix_switch.dart';

class LullabiesPage extends ConsumerWidget {
  const LullabiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final switchValue=ref.watch(switchProvider);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 12,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            if(!switchValue) {
              await ref.watch(audioPlayerProvider.notifier).startPlay(songs, index);
            }
          },
          child: LullabiesSoundWidget(song: songs[index]),
        );
      },gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: MediaQuery.of(context).size.width > 600
          ? (MediaQuery.of(context).size.width > 400
          ? (MediaQuery.of(context).size.width > 200
          ? 10
          : 8)
          : 6)
          : 4,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
    ),
    );
  }
}