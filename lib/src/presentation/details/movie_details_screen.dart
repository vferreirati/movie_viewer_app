import 'package:flutter/material.dart';

import '../../common/app_color.dart';
import '../../domain/model/movie.dart';
import '../widgets/search_app_bar.dart';
import 'widgets/movie_poster_score_wrapper.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: SearchAppBar(
        title: movie.title,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoviePosterScoreWrapper(
                score: movie.score,
                url: movie.posterURL,
              ),
              const SizedBox(height: 12.0),
              Text(
                movie.releaseDate,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColor.primary,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                movie.description,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColor.primary,
                  height: 1.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
