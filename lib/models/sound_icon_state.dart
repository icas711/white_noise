import 'package:audio_service/audio_service.dart' show AudioServiceRepeatMode, AudioServiceShuffleMode, MediaItem;

class SoundIconState{
  final bool playingFirst;
  final bool playingSecond;
  final List<MediaItem> queue;
  final int queueIndex;
  final int queueSecondIndex;
  final AudioServiceShuffleMode shuffleMode;
  final AudioServiceRepeatMode repeatMode;
  final Duration progress;
  final Duration total;

  SoundIconState({
    this.playingFirst = false,
    this.playingSecond=false,
    required this.queue,
    this.queueIndex = 0,
    this.queueSecondIndex = -1,
    this.shuffleMode = AudioServiceShuffleMode.all,
    this.repeatMode = AudioServiceRepeatMode.one,
    this.progress = Duration.zero,
    this.total = Duration.zero,
  });


  MediaItem? get currentSong {
    if (queue.isNotEmpty && queueIndex < queue.length && queueIndex > -1) return queue[queueIndex];
    return null;
  }

  SoundIconState copyWith({
    bool? playingFirst,
    bool? playingSecond,
    List<MediaItem>? queue,
    int? queueIndex,
    int? queueSecondIndex,
    AudioServiceShuffleMode? shuffleMode,
    AudioServiceRepeatMode? repeatMode,
    Duration? progress,
    Duration? total,
  }) {
    return SoundIconState(
      playingFirst: playingFirst ?? this.playingFirst,
      playingSecond: playingSecond ?? this.playingSecond,
      queue: queue ?? this.queue,
      queueIndex: queueIndex ?? this.queueIndex,
      queueSecondIndex: queueSecondIndex ?? this.queueSecondIndex,
      shuffleMode: shuffleMode ?? this.shuffleMode,
      repeatMode: repeatMode ?? this.repeatMode,
      progress: progress ?? this.progress,
      total: total ?? this.total,
    );
  }
}
