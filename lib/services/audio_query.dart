import 'dart:io';

import 'package:audio_service/audio_service.dart' show MediaItem;
class AudioQuery {

  Future<List<MediaItem>> queryMediaItems() async {
    final countryCode = Platform.localeName.split('_')[1];
    List soundNamesRu = [
      'Колыбельная №1',
      'Колыбельная №2',
      'Колыбельная №3',
      'Колыбельная №4',
      'Колыбельная №5',
      'Колыбельная №6',
      'Колыбельная №7',
      'Колыбельная №8',
      'Колыбельная №9',
      'Колыбельная №10',
      'Колыбельная №11',
      'Колыбельная №12',
      'Белый шум',
      'Коричневый шум',
      'Розовый шум',
      'Самолет',
      'Автобус',
      'Машина',
      'Кошка',
      'Океан',
      'Поезд',
      'Огонь',
      'Лес',
      'Ночь',
      'Ветер',
      'Дождь',
      'Ручей',
      'Вентилятор',
      'Пылесос',
      'Фен',
      'Стиральная машина',
      'Пульс',
      'Душ',
      'Река',
      'Часы',
      'Женщина',
      'Мужчина',
      'Шшш...',
      'Шшш...Шшш...',
      'Шшш...Шшш...Шшш...'
    ];

    List soundNamesEng = [
      'Lullabie #1',
      'Lullabie #2',
      'Lullabie #3',
      'Lullabie #4',
      'Lullabie #5',
      'Lullabie #6',
      'Lullabie #7',
      'Lullabie #8',
      'Lullabie #9',
      'Lullabie #10',
      'Lullabie #11',
      'Lullabie #12',
      'White noise',
      'Brown noise',
      'Pink noise',
      'Plaine',
      'Bus',
      'Car',
      'Cat',
      'Ocean',
      'Train',
      'Fire',
      'Forest',
      'Night',
      'Wind',
      'Rain',
      'Creek',
      'Fan',
      'Vacuum cleaner',
      'Hairdryer',
      'Washing machine',
      'Heartbeat',
      'Shower',
      'River',
      'Clock',
      'Female',
      'Male',
      'Sh...',
      'Sh...Sh...',
      'Sh...Sh...Sh...'
    ];

    final soundNames = [
      'lullaby0',
      'lullaby1',
      'lullaby2',
      'lullaby3',
      'lullaby4',
      'lullaby5',
      'lullaby6',
      'lullaby7',
      'lullaby8',
      'lullaby9',
      'lullaby10',
      'lullaby11',
      'white_noise',
      'brown_noise',
      'pink_noise',
      'airplane',
      'bus',
      'car',
      'cat',
      'ocean',
      'train',
      'fire',
      'forest',
      'night',
      'wind',
      'rain',
      'creek',
      'fan',
      'vacuum-cleaner',
      'hair-dryer',
      'washing-machine',
      'heartbeat',
      'shower',
      'river',
      'clock',
      'female',
      'male',
      'sh',
      'shsh',
      'shshsh',
    ];

    List<int> soundsDuration = [
      34,
      172,
      43,
      30,
      93,
      74,
      89,
      64,
      270,
      180,
      60,
      253,
      21,
      23,
      20,
      17,
      15,
      35,
      11,
      49,
      30,
      21,
      60,
      21,
      36,
      18,
      45,
      25,
      5,
      9,
      7,
      2,
      18,
      6,
      16,
      26,
      35,
      5,
      5,
      7,
    ];
    int i = 0;
    final List<MediaItem> mediaItems = [];
    for (final song in soundNames) {
      mediaItems.add(
        MediaItem(
          id: i.toString(),
          title: countryCode=='ru'?soundNamesRu[i]:soundNamesEng[i],
          extras: {'duration':soundsDuration[i], 'name':song},
        ),
      );
      i++;
    }

    return mediaItems;
  }
}
