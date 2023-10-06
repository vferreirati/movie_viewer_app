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

    // if (url.isEmpty) {
    //   return MovieScoreIndicator(
    //     score: score,
    //     radius: radius,
    //   );
    // }

    return Padding(
      padding: url.isEmpty ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: url,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.6,
                width: double.infinity,
                decoration: url.isEmpty
                    ? BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      )
                    : null,
                padding: const EdgeInsets.only(top: radius),
                transform: Matrix4.translationValues(0.0, -radius, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: url.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.usb_rounded),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: MovieScoreIndicator(
                  score: score,
                  radius: radius,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
