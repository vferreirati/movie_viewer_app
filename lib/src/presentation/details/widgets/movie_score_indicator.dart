import 'package:flutter/material.dart';

import '../../../common/app_color.dart';

class MovieScoreIndicator extends StatelessWidget {
  final double score;
  final double radius;

  const MovieScoreIndicator({
    super.key,
    required this.score,
    this.radius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorValue = score / 10;
    final percentageValue = (score * 10).truncate();

    return Container(
      height: radius * 2,
      width: radius * 2,
      padding: const EdgeInsets.all(4.0),
      decoration: const BoxDecoration(
        color: AppColor.primary,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              value: indicatorValue,
              strokeWidth: 2.0,
              color: Colors.green,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '$percentageValue%',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
