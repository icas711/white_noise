import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/services/audio_query.dart';
import 'package:white_noise/ui/home/common_audio_screen.dart';
import 'package:white_noise/ui/loading/loading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //localizationsDelegates: AppLocalizations.localizationsDelegates,
      //supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          background: Colors.blueAccent,
          seedColor: Colors.white,
          brightness: Brightness.dark,
        ),
        fontFamily: 'MyFontFamily',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ru'), // Spanish
      ],
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  bool loading = true;

  late final List<MediaItem> mediaItems;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final audioApi = AudioQuery();
    mediaItems = await audioApi.queryMediaItems();
    ref.read(songsProvider.notifier).update((state) => mediaItems);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const LoadingScreen() : const AudioScreen();
  }
}
