import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/movie.dart';
import '../../domain/model/movie_filter.dart';
import '../../domain/use_case/list_movies_use_case.dart';
import '../../domain/use_case/query_movies_use_case.dart';
import 'pagination.dart';

/// Enum that represents all possible actions of [MoviesCubit].
enum MoviesAction {
  /// No action is being performed
  none,

  /// The first page of data is being loaded
  loadingInitial,

  /// Another page of data is being loaded
  loadingMore,
}

/// Enum that represents all possible errors of [MoviesCubit].
enum MoviesError {
  /// A network failure happened.
  network,

  /// A generic failure happened
  generic
}

/// Data class that represents the state of the [MoviesCubit].
class MoviesState extends Equatable {
  /// The list of movies being displayed by the cubit
  final UnmodifiableListView<Movie> movies;

  /// The current action being performed.
  final MoviesAction action;

  /// The last error emitted.
  final MoviesError? error;

  /// The current filter being applied
  final MovieFilter filter;

  /// The current query being applied
  final String query;

  /// The pagination information.
  final Pagination pagination;

  /// Creates a new [MoviesState] instance.
  MoviesState({
    required this.pagination,
    Iterable<Movie> movies = const [],
    this.action = MoviesAction.none,
    this.error,
    this.filter = MovieFilter.popular,
    this.query = '',
  }) : movies = UnmodifiableListView(movies);

  /// Creates a new instance with the provided parameters.
  MoviesState copyWith({
    Iterable<Movie>? movies,
    MoviesAction? action,
    MovieFilter? filter,
    MoviesError? error,
    bool clearError = false,
    String? query,
    Pagination? pagination,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      action: action ?? this.action,
      filter: filter ?? this.filter,
      query: query ?? this.query,
      pagination: pagination ?? this.pagination,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        movies,
        action,
        error,
        filter,
        query,
        pagination,
      ];
}

/// Cubit responsible for listing and querying [Movies]
class MoviesCubit extends Cubit<MoviesState> {
  final ListMoviesUseCase _listMoviesUseCase;
  final QueryMoviesUseCase _queryMoviesUseCase;

  /// Creates a new [MoviesCubit] instance
  MoviesCubit({
    required ListMoviesUseCase listMoviesUseCase,
    required QueryMoviesUseCase queryMoviesUseCase,
  })  : _listMoviesUseCase = listMoviesUseCase,
        _queryMoviesUseCase = queryMoviesUseCase,
        super(
          MoviesState(
            pagination: const Pagination(
              size: 20,
            ),
          ),
        );

  /// Fetches a new list of movies
  ///
  /// Use the `query` parameter to query the data.
  ///
  /// Use the `nextPage` parameter to signal that a new page of data
  /// should be loaded.
  /// Defaulst to `false`.
  Future<void> listMovies({
    String query = '',
    bool nextPage = false,
  }) async {
    final effectiveQuery = query.trim();

    emit(
      state.copyWith(
        clearError: true,
        action:
            nextPage ? MoviesAction.loadingMore : MoviesAction.loadingInitial,
        query: effectiveQuery,
      ),
    );

    try {
      final page = nextPage ? state.pagination.page + 1 : 1;

      final results = effectiveQuery.isEmpty
          ? await _listMoviesUseCase(
              filter: state.filter.dtoValue,
              page: page,
            )
          : await _queryMoviesUseCase(
              query: effectiveQuery,
              page: page,
            );

      final effectiveResults = nextPage
          ? [
              ...state.movies,
              ...results,
            ]
          : results;

      final canLoadMore = results.length >= state.pagination.size;
      final newPagination = nextPage
          ? state.pagination.paginate(
              canLoadMore: canLoadMore,
            )
          : state.pagination.copyWith(
              canLoadMore: canLoadMore,
              page: 1,
            );

      emit(
        state.copyWith(
          action: MoviesAction.none,
          movies: effectiveResults,
          pagination: newPagination,
        ),
      );
    } on Exception catch (e) {
      final effectiveError =
          e is DioException ? MoviesError.network : MoviesError.generic;

      emit(
        state.copyWith(
          error: effectiveError,
          action: MoviesAction.none,
        ),
      );
    }
  }

  /// Applies a new [MovieFilter] and triggers the load of new data.
  void setFilter({
    required MovieFilter filter,
  }) {
    emit(state.copyWith(filter: filter));

    listMovies();
  }
}
