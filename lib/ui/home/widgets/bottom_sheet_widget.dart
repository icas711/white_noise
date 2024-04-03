import 'package:flutter/material.dart';
import 'package:white_noise/ui/home/widgets/duration_timer_text.dart';
import 'package:white_noise/ui/home/widgets/slider_volume.dart';
import 'package:white_noise/ui/home/widgets/volume_button.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 120,
      ),
      child: const Column(
        children: [
          SizedBox(
            height: 8,
          ),
          VolumeButton(),
          DurationTimerText(),

          /*Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Icon(Icons.volume_down),
              ),
              Expanded(
                child: SliderVolume(),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.volume_up),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
