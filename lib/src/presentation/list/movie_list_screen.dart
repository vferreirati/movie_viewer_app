import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

import '../../common/app_color.dart';
import '../../domain/model/movie_filter.dart';
import '../extensions/movie_error_ui_extension.dart';
import '../extensions/movie_filter_ui_extension.dart';
import '../widgets/error_indicator.dart';
import '../widgets/search_app_bar.dart';
import 'movies_cubit.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filter = context.select<MoviesCubit, MovieFilter>(
      (c) => c.state.filter,
    );

    return Scaffold(
      appBar: SearchAppBar(
        title: 'Movie viewer',
        onSearchChanged: (query) => context.read<MoviesCubit>().listMovies(
              query: query,
            ),
        extraActions: [
          PopupMenuButton<MovieFilter>(
            color: Colors.white,
            initialValue: filter,
            onSelected: (newFilter) => context.read<MoviesCubit>().setFilter(
                  filter: newFilter,
                ),
            itemBuilder: (context) => MovieFilter.values
                .map(
                  (e) => PopupMenuItem<MovieFilter>(
                    value: e,
                    child: Text(e.localization),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: const _MoviesContent(),
    );
  }
}

class _MoviesContent extends StatelessWidget {
  const _MoviesContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MoviesCubit>().state;

    final movies = state.movies;
    final errorMessage = state.error?.localization;
    final canLoadMore = state.pagination.canLoadMore;
    final loadingMore = state.action != MoviesAction.none;

    return InfiniteList(
      itemCount: movies.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 4.0),
      onFetchData: () => context.read<MoviesCubit>().listMovies(
            nextPage: true,
            query: state.query,
          ),
      centerEmpty: true,
      centerError: true,
      hasError: state.error != null,
      isLoading: loadingMore,
      hasReachedMax: !canLoadMore,
      emptyBuilder: (context) => const Center(
        child: Text('No results'),
      ),
      errorBuilder: (context) => ErrorIndicator(
        onRetry: () => context.read<MoviesCubit>().listMovies(
              query: state.query,
            ),
        message: errorMessage!,
      ),
      separatorBuilder: (context, index) {
        final effectiveIndex = index + 1;
        final shouldAddBox = index > 0 && effectiveIndex % 5 == 0;

        return shouldAddBox
            ? Container(
                height: 50.0,
                color: AppColor.primary,
              )
            : const Divider();
      },
      loadingBuilder: (context) => const LinearProgressIndicator(),
      itemBuilder: (context, index) {
        final movie = movies[index];

        return ListTile(
          title: Text(movie.title),
          leading: movie.posterURL.isNotEmpty
              ? Hero(
                  tag: movie.posterURL,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      movie.posterURL,
                    ),
                  ),
                )
              : null,
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).dividerColor,
          ),
          subtitle: Text(
            movie.releaseDate,
          ),
          onTap: () => context.push(
            '/details',
            extra: movie,
          ),
        );
      },
    );
  }
}
