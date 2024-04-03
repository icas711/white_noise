import 'package:audio_service/audio_service.dart'
    show
        AudioHandler,
        AudioService,
        AudioServiceRepeatMode,
        AudioServiceShuffleMode,
        MediaItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/models/sound_icon_state.dart';
import 'package:white_noise/riverpod/time_provider.dart';

class SoundIconNotifier extends StateNotifier<SoundIconState> {
  final ref;

  SoundIconNotifier(this._audioHandler, this.ref)
      : super(SoundIconState(queue: [])) {
    _audioHandler.playbackState.listen(
      (playbackState) {
        state = state.copyWith(
          playingFirst: playbackState.playing,
          queueIndex: playbackState.queueIndex,
          //progress: playbackState.updatePosition,
          shuffleMode: playbackState.shuffleMode,
          repeatMode: playbackState.repeatMode,
        );
      },
    );

    _audioHandler.queue.listen((List<MediaItem> queue) {
      state = state.copyWith(queue: queue);
    });

    _audioHandler.mediaItem.listen((MediaItem? mediaItem) {
      state = state.copyWith(
        total: mediaItem?.duration,
      );
    });
    AudioService.position.listen((Duration position) {
      state = state.copyWith(progress: position);
    });
  }

  final AudioHandler _audioHandler;

  Future<void> stop() async {
    if (state.playingFirst) {
      await _audioHandler.stop();
    }
  }

  Future<void> stop2() async {
    if (state.playingSecond) {
      state = state.copyWith(queueSecondIndex: -1, playingSecond: false);
      await _audioHandler.pause();
    }
  }

  Future<void> stopAll() async {
    if (state.playingFirst) {
      await _audioHandler.stop();
    }
    if (state.playingSecond) {
      state = state.copyWith(queueSecondIndex: -1, playingSecond: false);
      await _audioHandler.pause();
    }
    await _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
  }

  Future<void> playPause() async {
    if (state.playingFirst) {
      await _audioHandler.pause();
    } else {
      await _audioHandler.play();
    }
  }

  Future<void> startPlay(List<MediaItem> queue, int index) async {


    if (state.playingFirst) {
      if (state.queueIndex == index && state.queueSecondIndex < 0) {
        ref.read(countDownControllerProvider.notifier).stopTimer();
        await stop();
      } else if (state.queueIndex == index && state.queueSecondIndex >= 0) {
        await _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        final newIndex = state.queueSecondIndex;
        await stop2();
        await stop();
        await startOnePlay(queue, newIndex);
      } else if (state.queueSecondIndex == index) {
        await stop2();
        //  await startOnePlay(queue, state.queueIndex);
      } else if (state.queueSecondIndex < 0) {
        state = state.copyWith(queueSecondIndex: index, playingSecond: true);
        await _audioHandler
            .customAction('start2', {'queue': queue, 'index': index});
      }
    } else {
      await _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
      if(!ref.watch(countDownControllerProvider.notifier).isStarted()) {
        await ref.read(countDownControllerProvider.notifier).startTimer();
      }
      state = state.copyWith(queueIndex: index);
      await startOnePlay(queue, index);
    }
  }

  Future<void> startOnePlay(List<MediaItem> queue, int index) async {
    state = state.copyWith(queueIndex: index);
    await _audioHandler.customAction('start', {'queue': queue, 'index': index});
  }

  Future<void> startMix(List<MediaItem> queue, bool start) async {
    if (start) {
      await _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
      await _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
      if (state.playingFirst && !state.playingSecond) {
        await stop();
        // state = state.copyWith(queueIndex: -1);
        await startPlayMix(queue);
      } else if (!state.playingFirst && !state.playingSecond) {
        if(!ref.watch(countDownControllerProvider.notifier).isStarted()) {
          await ref.read(countDownControllerProvider.notifier).startTimer();
        }
        await startPlayMix(queue);
      } else if (state.playingFirst && state.playingSecond) {
        return;
      }
    } else {
      await _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
      if (state.playingSecond) {
        final index = state.queueSecondIndex;
        await stop();
        await stop2();
        state = state.copyWith(queueIndex: index);

        await startOnePlay(queue, index);
      } else {
        ref.read(countDownControllerProvider.notifier).stopTimer();
        await stop();
      }
    }
  }

  Future<void> startPlayMix(List<MediaItem> queue) async {
    await _audioHandler.customAction('startMix', {'queue': queue});
  }

  void reOrderQueue(int oldIndex, int newIndex) {
    _audioHandler
        .customAction('reorder', {'oldIndex': oldIndex, 'newIndex': newIndex});
  }

  Future<void> setVolume1(double volume) async =>
      _audioHandler.customAction('setVolume1', {'volume': volume});

  Future<void> setVolume2(double volume) async =>
      _audioHandler.customAction('setVolume2', {'volume': volume});

  Future<dynamic> volumeStream() async =>
      _audioHandler.customAction('volumeStream');

  Future<void> skipToNext() async => _audioHandler.skipToNext();

  void skipToPrevious() => _audioHandler.skipToPrevious();

  void skipToQueueItem(int index) => _audioHandler.skipToQueueItem(index);

  void removeQueueItemAt(int index) => _audioHandler.removeQueueItemAt(index);

  void changeShuffleMode() {
    switch (state.shuffleMode) {
      case AudioServiceShuffleMode.none:
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
        break;
      case AudioServiceShuffleMode.all:
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
        break;
      case AudioServiceShuffleMode.group:
        //Not used
        break;
    }
  }
}
