import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/ui/home/widgets/song_widget.dart';

class ShushingPage extends ConsumerWidget {
  const ShushingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final noises=songs.getRange(37, 40).toList();
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            await ref.watch(audioPlayerProvider.notifier).startPlay(songs, index+37);
          },
          child: SongWidget(song: noises[index]),
        );
      },gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: MediaQuery.of(context).size.width > 600
          ? (MediaQuery.of(context).size.width > 400
          ? (MediaQuery.of(context).size.width > 200
          ? 3
          : 8)
          : 6)
          : 4,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
    ),
    );
  }
}