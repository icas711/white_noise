import 'package:audio_service/audio_service.dart' show MediaItem;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';

class SongWidget extends ConsumerWidget {
  const SongWidget({super.key, required this.song});

  final MediaItem song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstSong =
        ref.watch(audioPlayerProvider.select((value) => value.queueIndex));
    final secondSong = ref
        .watch(audioPlayerProvider.select((value) => value.queueSecondIndex));
    final playing =
        ref.watch(audioPlayerProvider.select((value) => value.playingFirst));

    return SizedBox(
      height: 65,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 2,
              ),
              color: playing
                  ? firstSong.toString() == song.id
                      ? Colors.greenAccent
                      : secondSong.toString() == song.id
                          ? Colors.greenAccent
                          : Colors.white
                  : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/img/${song.extras!['name']}.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
