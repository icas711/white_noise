import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:white_noise/buttons/fab.dart';
import 'package:white_noise/core/utils/network_provider.dart';
import 'package:white_noise/ui/home/screen/humming_screen.dart';
import 'package:white_noise/ui/home/screen/lullabies_screen.dart';
import 'package:white_noise/ui/home/screen/noises_screen.dart';
import 'package:white_noise/ui/home/screen/shushing_screen.dart';
import 'package:white_noise/ui/home/screen/sounds_scree.dart';
import 'package:white_noise/ui/home/widgets/app_rate_widget.dart';
import 'package:white_noise/ui/home/widgets/bottom_sheet_widget.dart';
import 'package:white_noise/ui/home/widgets/custom_image_icon.dart';
import 'package:white_noise/ui/home/widgets/list_titles.dart';
import 'package:white_noise/ui/home/widgets/mix_switch.dart';
import 'package:yandex_mobileads/mobile_ads.dart';



class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 5,
    minLaunches: 7,
    remindDays: 4,
    remindLaunches: 5,
    appStoreIdentifier: '6470238705',
    googlePlayIdentifier: 'com.exo.white_noise',
  );

  final networks = NetworkProvider.instance.bannerNetworks;

  late String adUnitId = networks.first.adUnitId;
  AdRequest adRequest = const AdRequest();
  bool isLoading = false;
  bool isBannerAlreadyCreated = false;
  bool isSticky = true;
  late BannerAd banner;

  @override
  Future<void> initState() async {
    super.initState();

    await WidgetsBinding.instance.endOfFrame.then(
            (_) async {
      await rateMyApp.init();
      if (mounted) await _loadBanner();
      if (mounted && rateMyApp.shouldOpenDialog) {
        await showRateApp(rateMyApp, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    if (kDebugMode) {
      print(myLocale);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: isBannerAlreadyCreated ? AdWidget(bannerAd: banner) : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTitles(title: AppLocalizations.of(context)!.lullabies),
                    const LullabiesPage(),
                    const MixSwitch(),
                    ListTitles(
                        title: AppLocalizations.of(context)!.white_noise),
                    const NoisesPage(),
                    ListTitles(
                      title: AppLocalizations.of(context)!.sounds,
                    ),
                    const SoundsPage(),
                    ListTitles(
                      title: AppLocalizations.of(context)!.humming,
                    ),
                    const HummingPage(),
                    ListTitles(
                      title: AppLocalizations.of(context)!.shushing,
                    ),
                    const ShushingPage(),
                    const SizedBox(
                      height: 150,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        transform: Matrix4.translationValues(0, 0, 0),
        child: ExpandableFab(
          distance: 150,
          children: [
            const CustomActionButton(fileName: 'infinity', duration: 9999999),
            CustomActionButton(
                fileName: '${myLocale.languageCode}5m', duration: 300),
            CustomActionButton(
                fileName: '${myLocale.languageCode}30m', duration: 1800),
            CustomActionButton(
                fileName: '${myLocale.languageCode}1h', duration: 3600),
            CustomActionButton(
                fileName: '${myLocale.languageCode}4h', duration: 4 * 3600),
            CustomActionButton(
                fileName: '${myLocale.languageCode}8h', duration: 8 * 3600),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomSheet: const BottomSheetWidget(),
    );
  }

  Future<void> _loadBanner() async {
    final windowSize = MediaQuery.of(context).size;
    setState(() => isLoading = true);
    if (isBannerAlreadyCreated) {
      await banner.loadAd(adRequest: adRequest);
    } else {
      final adSize = isSticky
          ? BannerAdSize.sticky(width: windowSize.width.toInt()==0
          ? WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width.toInt()
          : windowSize.width.toInt())
          : BannerAdSize.inline(
              width: windowSize.width.toInt(),
              maxHeight: windowSize.height ~/ 3,
            );
      final calculatedBannerSize = await adSize.getCalculatedBannerAdSize();
      debugPrint('calculatedBannerSize: $calculatedBannerSize');
      banner = _createBanner(adSize);

      setState(() {
        isBannerAlreadyCreated = true;
      });
    }
  }

  BannerAd _createBanner(BannerAdSize adSize) {
    return BannerAd(
      adUnitId: adUnitId,
      adSize: adSize,
      adRequest: adRequest,
      onAdLoaded: () {
        setState(() {
          isLoading = false;
        });
        debugPrint('callback: banner ad loaded');
      },
      onAdFailedToLoad: (error) {
        setState(() => isLoading = false);
        debugPrint('callback: banner ad failed to load, '
            'code: ${error.code}, description: ${error.description}');
      },
      onAdClicked: () => debugPrint('callback: banner ad clicked'),
      onLeftApplication: () => debugPrint('callback: left app'),
      onReturnedToApplication: () => debugPrint('callback: returned to app'),
      onImpression: (data) =>
          debugPrint('callback: impression: ${data.getRawData()}'),
    );
  }
}
