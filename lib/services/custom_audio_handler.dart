import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart' show AudioProcessingState, AudioServiceRepeatMode, AudioServiceShuffleMode, BaseAudioHandler, MediaControl, MediaItem;
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class CustomAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  var _playList = ConcatenatingAudioSource(children: []);
  var _playMixList = ConcatenatingAudioSource(children: []);
  final _player2 = AudioPlayer();
  bool isLoaded = false;

  CustomAudioHandler() {
    unawaited(_player2.setLoopMode(LoopMode.one));
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
     _listenForShuffleModeChanges();
     _listenForRepeatModeChanges();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen(
      (event) {
        final playing = _player.playing;
        final queueIndex =
            _player.effectiveIndices?.indexOf(_player.currentIndex ?? 0);
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              MediaControl.stop,
            ],
            androidCompactActionIndices: const [2],
            processingState: const {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.ready: AudioProcessingState.ready,
              ProcessingState.completed: AudioProcessingState.completed,
            }[_player.processingState]!,
            repeatMode: const {
              LoopMode.off: AudioServiceRepeatMode.none,
              LoopMode.one: AudioServiceRepeatMode.one,
              LoopMode.all: AudioServiceRepeatMode.all,
            }[_player.loopMode]!,
            shuffleMode: _player.shuffleModeEnabled
                ? AudioServiceShuffleMode.all
                : AudioServiceShuffleMode.none,
            playing: playing,
            updatePosition: _player.position,
            bufferedPosition: _player.bufferedPosition,
            // speed: _player.speed,
            queueIndex: queueIndex,
          ),
        );
      },
    );
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;

      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      if (index < playlist.length && index > -1) {
        mediaItem.add(playlist[index]);
      }
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen(
      (SequenceState? sequenceState) {
        try {
          final sequence = sequenceState?.effectiveSequence;

          if (sequence == null || sequence.isEmpty) return;
          final items = sequence.map((source) => source.tag as MediaItem);
          queue.add(items.toList());
        }
        catch(e){
          if (kDebugMode) {
            print('wtf error!');
          }
        }
      },
    );
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen(
      (duration) {
        var index = _player.currentIndex;
        final newQueue = queue.value;
        if (index == null || newQueue.isEmpty) return;

        if (_player.shuffleModeEnabled) {
          index = _player.shuffleIndices!.indexOf(index);
        }
        final oldMediaItem = newQueue[index];
        final newMediaItem = oldMediaItem.copyWith(duration: Duration.zero);
        newQueue[index] = newMediaItem;
        mediaItem.add(newMediaItem);
      },
    );
  }

  void _listenForShuffleModeChanges() {
    _player.shuffleModeEnabledStream.listen(
      (enabled) {
        int? queueIndex = _player.currentIndex;
        if (queueIndex != null) {
          if (queueIndex < queue.value.length && queueIndex > -1) {
            queueIndex =
                _player.effectiveIndices?.indexOf(_player.currentIndex ?? 0);
          }
        }
        playbackState.add(
          playbackState.value.copyWith(
            shuffleMode: enabled
                ? AudioServiceShuffleMode.all
                : AudioServiceShuffleMode.none,
            queueIndex: queueIndex,
          ),
        );
      },
    );
  }

  void _listenForRepeatModeChanges() {
    _player.loopModeStream.listen(
      (loopMode) {
        late AudioServiceRepeatMode repeatMode;
        switch (loopMode) {
          case LoopMode.off:
            repeatMode = AudioServiceRepeatMode.none;
            break;
          case LoopMode.one:
            repeatMode = AudioServiceRepeatMode.one;
            break;
          case LoopMode.all:
            repeatMode = AudioServiceRepeatMode.all;
            break;
        }
        playbackState.add(
          playbackState.value.copyWith(
            repeatMode: repeatMode,
          ),
        );
      },
    );
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.asset(
      'assets/audio/${mediaItem.extras!['name']}.mp3',
      tag: mediaItem,
    );
  }

  @override
  Future<void> play() => _player.play();

  Future<void> play2() {
    return _player2.play();
  }

  Future<void> stop2() => _player2.stop();

  @override
  Future<void> pause() => _player2.stop();

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> removeQueueItemAt(int index) => _playList.removeAt(index);

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
        break;
      case AudioServiceRepeatMode.all:
        await _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      await _player.setShuffleModeEnabled(false);
    } else {
      await _player.setShuffleModeEnabled(true);
      await _player.shuffle();
    }
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value
        .copyWith(processingState: AudioProcessingState.completed));
    await _player.stop();
    await _player2.stop();
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'setVolume1':
        {
          return _player.setVolume(extras!['volume']);
        }
        break;
      case 'setVolume2':
        {
          return _player2.setVolume(extras!['volume']);
        }
        break;
      case 'volumeStream':
        {
          return [_player.volumeStream, _player2.volumeStream];
        }
        break;
      case 'volume':
        {
          return _player.volume;
        }
        break;
      case 'start':
        {

            final source = await extras!['queue']
                .map(_createAudioSource)
                .toList()
                .cast<AudioSource>();
            //queue.add(extras['queue']);
            _playList = ConcatenatingAudioSource(children: source);

          await _player.setAudioSource(
            _playList,
            initialIndex: extras!['index'],
          );
          await play();
        }
        break;
      case 'start2':
        {
          final source = await extras!['queue']
              .map(_createAudioSource)
              .toList()
              .cast<AudioSource>();
          _playList = ConcatenatingAudioSource(children: source);
          await _player2.setAudioSource(
            _playList,
            initialIndex: extras!['index'],
          );
          await play2();
        }
        break;
      case 'startMix':
        {
          final intValue = Random().nextInt(12);
          final source = await extras!['queue']
              .map(_createAudioSource)
              .toList()
              .cast<AudioSource>();
          final mixQueue = await source.getRange(0, 12).toList();

          //await _player.setShuffleModeEnabled(true);
          //await _player.setLoopMode(LoopMode.all);

          _playMixList = ConcatenatingAudioSource(children: mixQueue);

          await _player.setAudioSource(
            _playMixList,
            initialIndex: intValue,
          );
          await _player.setShuffleModeEnabled(true);
          await _player.setLoopMode(LoopMode.all);
          await _player.play();
        }
        break;
    }
  }
}
