import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/app_color.dart';
import 'data/repository/movie_repository_impl.dart';
import 'data/service/movies_service.dart';
import 'domain/model/movie.dart';
import 'domain/repository/movie_repository.dart';
import 'domain/use_case/list_movies_use_case.dart';
import 'domain/use_case/query_movies_use_case.dart';
import 'presentation/details/movie_details_screen.dart';
import 'presentation/list/movie_list_screen.dart';
import 'presentation/list/movies_cubit.dart';

class TMDBApp extends StatefulWidget {
  final Dio client;

  const TMDBApp({
    super.key,
    required this.client,
  });

  @override
  State<TMDBApp> createState() => _TMDBAppState();
}

class _TMDBAppState extends State<TMDBApp> {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (_) => MoviesCubit(
            listMoviesUseCase: ListMoviesUseCase(
              repository: Provider.of(context),
            ),
            queryMoviesUseCase: QueryMoviesUseCase(
              repository: Provider.of(context),
            ),
          )..listMovies(),
          child: const MovieListScreen(),
        ),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) => MovieDetailsScreen(
          movie: state.extra as Movie,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MovieRepository>(
          create: (_) => MovieRepositoryImpl(
            service: MovieService(
              client: widget.client,
            ),
          ),
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp.router(
          routerConfig: _router,
          theme: ThemeData(
            primaryColor: AppColor.primary,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
