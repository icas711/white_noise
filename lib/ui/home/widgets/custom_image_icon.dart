import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise/riverpod/providers.dart';
import 'package:white_noise/riverpod/time_provider.dart';
import 'package:white_noise/buttons/fab.dart';

class CustomActionButton extends ConsumerWidget {
  final String fileName;
  final int duration;

  const CustomActionButton({
    super.key,
    required this.fileName,
    required this.duration,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActionButton(
      onPressed: () async {
        ref.read(countDownControllerProvider.notifier).addTime(duration: duration);
        ref.read(fabOpened.notifier).update((state) => false);
        ref.read(fabImage.notifier).update((state) => fileName);
      },
      icon: ImageIcon(
        size: 50,
        AssetImage('assets/icons/$fileName.png'),
      ),
      color: const Color(0xFF3A5A98),
    );
  }
}
