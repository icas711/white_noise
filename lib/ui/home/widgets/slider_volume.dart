import 'dart:async';

import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class SliderVolume extends StatefulWidget{
  @override
  State<SliderVolume> createState() => _SliderVolumeState();
}

class _SliderVolumeState extends State<SliderVolume> {
  double _setVolumeValue = 0;
  double _volumeListenerValue = 0;

  @override
  void initState() {
    super.initState();
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    unawaited(VolumeController().getVolume().then((volume) => _setVolumeValue = volume));
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0,
      max: 1,
      onChanged: (double value) {
        setState(() {
          _setVolumeValue = value;
          VolumeController().setVolume(_setVolumeValue);
        });
      },
      value: _setVolumeValue,
    );
  }
}