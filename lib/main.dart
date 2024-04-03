import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/services/custom_audio_handler.dart';
import 'package:white_noise/ui/home_screen.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioHandler = await AudioService.init(
    builder: CustomAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.exo.wn.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  await MobileAds.initialize();
  final countryCode = Platform.localeName.split('_')[1];
  if (countryCode == 'RU') {
    await MobileAds.setUserConsent(true);
  }
  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const HomeScreen(),
    ),
  );
}
