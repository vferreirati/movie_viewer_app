import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_app/src/domain/model/movie.dart';
import 'package:tmdb_app/src/domain/model/movie_filter.dart';
import 'package:tmdb_app/src/domain/use_case/list_movies_use_case.dart';
import 'package:tmdb_app/src/domain/use_case/query_movies_use_case.dart';
import 'package:tmdb_app/src/presentation/list/movies_cubit.dart';
import 'package:tmdb_app/src/presentation/list/pagination.dart';

class MockListMoviesUseCase extends Mock implements ListMoviesUseCase {}

class MockQueryMoviesUseCase extends Mock implements QueryMoviesUseCase {}

late ListMoviesUseCase _listMoviesUseCase;
late QueryMoviesUseCase _queryMoviesUseCase;

MoviesCubit _build() => MoviesCubit(
      listMoviesUseCase: _listMoviesUseCase,
      queryMoviesUseCase: _queryMoviesUseCase,
    );

void main() {
  setUp(() {
    _listMoviesUseCase = MockListMoviesUseCase();
    _queryMoviesUseCase = MockQueryMoviesUseCase();
  });

  group('MoviesCubit.listMovies() Failure test cases', () {
    blocTest<MoviesCubit, MoviesState>(
      'Handles generic errors gracefully',
      setUp: () {
        when(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).thenThrow(Exception());
      },
      build: _build,
      act: (c) => c.listMovies(),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingInitial,
          pagination: const Pagination(size: 20),
        ),
        MoviesState(
          action: MoviesAction.none,
          pagination: const Pagination(size: 20),
          error: MoviesError.generic,
        ),
      ],
      verify: (bloc) {
        verify(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).called(1);
      },
    );

    blocTest<MoviesCubit, MoviesState>(
      'Handles network errors gracefully',
      setUp: () {
        when(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).thenThrow(
          DioException.requestCancelled(
            requestOptions: RequestOptions(),
            reason: '',
          ),
        );
      },
      build: _build,
      act: (c) => c.listMovies(),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingInitial,
          pagination: const Pagination(size: 20),
        ),
        MoviesState(
          action: MoviesAction.none,
          pagination: const Pagination(size: 20),
          error: MoviesError.network,
        ),
      ],
      verify: (bloc) {
        verify(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).called(1);
      },
    );
  });

  final movies = List.generate(20, (index) => Movie(title: 'Movie $index'));

  group('MoviesCubit.listMovies() Success test cases', () {
    blocTest<MoviesCubit, MoviesState>(
      'Fetches the initial list of movies successfully',
      setUp: () {
        when(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((invocation) async => movies);
      },
      build: _build,
      act: (c) => c.listMovies(),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingInitial,
          pagination: const Pagination(size: 20),
        ),
        MoviesState(
          action: MoviesAction.none,
          pagination: const Pagination(
            size: 20,
            canLoadMore: true,
          ),
          movies: movies,
        ),
      ],
      verify: (bloc) {
        verify(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).called(1);
      },
    );

    blocTest<MoviesCubit, MoviesState>(
      'Fetches the initial list of movies successfully and correctly sets canLoadMore',
      setUp: () {
        when(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((invocation) async => movies.take(5).toList());
      },
      build: _build,
      act: (c) => c.listMovies(),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingInitial,
          pagination: const Pagination(size: 20),
        ),
        MoviesState(
          action: MoviesAction.none,
          pagination: const Pagination(
            size: 20,
            canLoadMore: false,
          ),
          movies: movies.take(5),
        ),
      ],
      verify: (bloc) {
        verify(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: any(named: 'page'),
          ),
        ).called(1);
      },
    );

    const query = 'something';
    blocTest<MoviesCubit, MoviesState>(
      'Queries a list of movies successfully',
      setUp: () {
        when(
          () => _queryMoviesUseCase(
            query: query,
            page: any(named: 'page'),
          ),
        ).thenAnswer((invocation) async => movies);
      },
      build: _build,
      act: (c) => c.listMovies(query: query),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingInitial,
          pagination: const Pagination(size: 20),
          query: query,
        ),
        MoviesState(
          query: query,
          action: MoviesAction.none,
          pagination: const Pagination(
            size: 20,
            canLoadMore: true,
          ),
          movies: movies,
        ),
      ],
      verify: (bloc) {
        verify(
          () => _queryMoviesUseCase(
            query: query,
            page: any(named: 'page'),
          ),
        ).called(1);
      },
    );

    blocTest<MoviesCubit, MoviesState>(
      'Queries a list of movies successfully and correctly sets canLoadMore',
      setUp: () {
        when(
          () => _queryMoviesUseCase(
            query: query,
            page: any(named: 'page'),
          ),
        ).thenAnswer((invocation) async => movies.take(5).toList());
      },
      build: _build,
      act: (c) => c.listMovies(query: query),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingInitial,
          pagination: const Pagination(size: 20),
          query: query,
        ),
        MoviesState(
          query: query,
          action: MoviesAction.none,
          pagination: const Pagination(
            size: 20,
            canLoadMore: false,
          ),
          movies: movies.take(5),
        ),
      ],
      verify: (bloc) {
        verify(
          () => _queryMoviesUseCase(
            query: query,
            page: any(named: 'page'),
          ),
        ).called(1);
      },
    );

    blocTest<MoviesCubit, MoviesState>(
      'Fetches the next page of movies successfully and correctly sets pagination',
      seed: () => MoviesState(
        pagination: const Pagination(size: 20),
        movies: movies.take(5),
      ),
      setUp: () {
        when(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: 2,
          ),
        ).thenAnswer((invocation) async => movies.skip(5).take(5).toList());
      },
      build: _build,
      act: (c) => c.listMovies(nextPage: true),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingMore,
          pagination: const Pagination(size: 20),
          movies: movies.take(5),
        ),
        MoviesState(
          action: MoviesAction.none,
          pagination: const Pagination(
            size: 20,
            canLoadMore: false,
            page: 2,
          ),
          movies: movies.take(10),
        ),
      ],
      verify: (bloc) {
        verify(
          () => _listMoviesUseCase(
            filter: any(named: 'filter'),
            page: 2,
          ),
        ).called(1);
      },
    );

    blocTest<MoviesCubit, MoviesState>(
      'Queries the next page of movies successfully and correctly sets pagination',
      seed: () => MoviesState(
        pagination: const Pagination(size: 20),
        movies: movies.take(5),
        query: query,
      ),
      setUp: () {
        when(
          () => _queryMoviesUseCase(
            query: query,
            page: 2,
          ),
        ).thenAnswer((invocation) async => movies.skip(5).take(5).toList());
      },
      build: _build,
      act: (c) => c.listMovies(nextPage: true, query: query),
      expect: () => [
        MoviesState(
          action: MoviesAction.loadingMore,
          pagination: const Pagination(size: 20),
          movies: movies.take(5),
          query: query,
        ),
        MoviesState(
          action: MoviesAction.none,
          pagination: const Pagination(
            size: 20,
            canLoadMore: false,
            page: 2,
          ),
          movies: movies.take(10),
          query: query,
        ),
      ],
      verify: (bloc) {
        verify(
          () => _queryMoviesUseCase(
            query: query,
            page: 2,
          ),
        ).called(1);
      },
    );
  });

  group('MoviesCubit.setFilter() Test cases', () {
    const filter = MovieFilter.nowPlaying;

    blocTest<MoviesCubit, MoviesState>(
      'Sets the filter correctly and reloads the list of data using the correct filter',
      setUp: () {
        when(
          () => _listMoviesUseCase(
            filter: filter.dtoValue,
            page: any(named: 'page'),
          ),
        ).thenAnswer((invocation) async => movies);
      },
      build: _build,
      act: (c) => c.setFilter(filter: filter),
      seed: () => MoviesState(
        pagination: const Pagination(size: 20),
        movies: movies.take(10),
        filter: MovieFilter.upcoming,
      ),
      expect: () => [
        MoviesState(
          pagination: const Pagination(size: 20),
          filter: filter,
          movies: movies.take(10),
        ),
        MoviesState(
          action: MoviesAction.loadingInitial,
          pagination: const Pagination(size: 20),
          filter: filter,
          movies: movies.take(10),
        ),
        MoviesState(
          action: MoviesAction.none,
          pagination: const Pagination(
            size: 20,
            canLoadMore: true,
          ),
          filter: filter,
          movies: movies,
        ),
      ],
      verify: (bloc) {
        verify(
          () => _listMoviesUseCase(
            filter: filter.dtoValue,
            page: any(named: 'page'),
          ),
        ).called(1);
      },
    );
  });
}
