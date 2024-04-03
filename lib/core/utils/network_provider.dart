import 'package:flutter/foundation.dart';

import 'package:white_noise/core/platform/network_ad.dart';

abstract class NetworkProvider {
  static final NetworkProvider instance = _createInstance();

  abstract final List<Network> bannerNetworks;
  abstract final List<Network> interstitialNetworks;
  abstract final List<Network> rewardedNetworks;

  static NetworkProvider _createInstance() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _AndroidNetworkProvider();
      case TargetPlatform.iOS:
        return _IosNetworkProvider();
      case TargetPlatform.windows:
        print('WINDOWS');
        return _WindowsNetworkProvider();
      default:
        throw UnsupportedError('The Yandex Mobile Ads SDK is only supported'
            ' on Android and iOS.');
    }
  }
}

class _AndroidNetworkProvider extends NetworkProvider {

  @override
  final List<Network> bannerNetworks = const [

    //GooglePlay banner
   // Network(title: 'Yandex', adUnitId: 'R-M-3345768-1'),

    //Rustore banner
   // Network(title: 'Yandex', adUnitId: 'R-M-4540187-1'),

    //Huawei store
    Network(title: 'Yandex', adUnitId: 'R-M-5398628-1'),
  ];

  @override
  final List<Network> interstitialNetworks = const [
    Network(title: 'Yandex', adUnitId: 'R-M-5620774-4'),
  ];

  @override
  final List<Network> rewardedNetworks = const [
    Network(title: 'Yandex', adUnitId: 'demo-rewarded-yandex'),
  ];
}

class _IosNetworkProvider extends NetworkProvider {
  @override
  final List<Network> bannerNetworks = const [
    Network(title: 'Yandex', adUnitId: 'R-M-3521393-1'),

  ];

  @override
  final List<Network> interstitialNetworks = const [
    Network(title: 'Yandex', adUnitId: 'R-M-5646034-2'),
  ];

  @override
  final List<Network> rewardedNetworks = const [
    Network(title: 'Yandex', adUnitId: 'demo-rewarded-yandex'),
  ];
}

class _WindowsNetworkProvider extends NetworkProvider {
  @override
  final List<Network> bannerNetworks = const [
    Network(title: 'Yandex', adUnitId: 'demo-banner-yandex'),

  ];

  @override
  final List<Network> interstitialNetworks = const [
    Network(title: 'Yandex', adUnitId: 'R-M-5646034-2'),
  ];

  @override
  final List<Network> rewardedNetworks = const [
    Network(title: 'Yandex', adUnitId: 'demo-rewarded-yandex'),
  ];
}