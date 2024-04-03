
import 'package:flutter/material.dart';
import 'package:white_noise/ui/loading/widgets/skeleton.dart';
import 'package:white_noise/ui/loading/widgets/song_skeleton.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + 40,
          20,
          80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skeleton(height: 30, width: 150),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Skeleton(height: 30)),
                SizedBox(width: 20),
                Expanded(child: Skeleton(height: 30)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                itemBuilder: (_, __) => const SongSkeleton(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
