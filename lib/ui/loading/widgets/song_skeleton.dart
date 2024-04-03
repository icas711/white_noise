import 'package:flutter/material.dart';
import 'package:white_noise/ui/loading/widgets/skeleton.dart';

class SongSkeleton extends StatelessWidget {
  const SongSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 65,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Skeleton(height: 60, width: 60),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(height: 15),
                SizedBox(height: 5),
                Skeleton(height: 30),
              ],
            ),
          ),
          SizedBox(width: 10),
          Skeleton(height: 25, width: 50),
        ],
      ),
    );
  }
}