import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'movie_score_indicator.dart';

class MoviePosterScoreWrapper extends StatelessWidget {
  final String url;
  final double score;

  const MoviePosterScoreWrapper({
    super.key,
    required this.url,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    const radius = 25.0;

    if (url.isEmpty) {
      return MovieScoreIndicator(
        score: score,
        radius: radius,
      );
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Hero(
            tag: url,
            child: Container(
              padding: const EdgeInsets.only(top: radius),
              transform: Matrix4.translationValues(0.0, -radius, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: url,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: MovieScoreIndicator(score: score),
            ),
          ),
        )
      ],
    );
  }
}
