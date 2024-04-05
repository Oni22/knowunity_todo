import 'package:flutter/material.dart';

class ProgessHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double progress;

  ProgessHeaderDelegate({required this.progress});
  // : assert(progress >= 0 && progress <= 1);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
              ),
            ),
            const SizedBox(width: 10),
            Text("${(progress * 100).toInt()}% 🔥")
          ],
        ));
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(ProgessHeaderDelegate oldDelegate) {
    // only rerennder if progress changes
    return oldDelegate.progress != progress;
  }
}
