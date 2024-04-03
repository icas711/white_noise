import 'package:audio_service/audio_service.dart' show AudioHandler, MediaItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/models/sound_icon_state.dart';

import '../models/sound_icon.dart';

final fabOpened = StateProvider((ref) => false);

final fabImage = StateProvider((ref) => 'reminder');

final songsProvider = StateProvider<List<MediaItem>>((ref) => []);

final audioHandlerProvider = Provider<AudioHandler>((ref) => throw UnimplementedError());

final audioPlayerProvider = StateNotifierProvider<SoundIconNotifier, SoundIconState>(
      (ref) => SoundIconNotifier(ref.read(audioHandlerProvider),ref),
);