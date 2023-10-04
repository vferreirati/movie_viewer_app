import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_app/src/domain/model/movie.dart';
import 'package:tmdb_app/src/domain/repository/movie_repository.dart';
import 'package:tmdb_app/src/domain/use_case/query_movies_use_case.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late QueryMoviesUseCase useCase;
  late var repo = MockMovieRepository();
  final movies = List.generate(
    5,
    (index) => Movie(title: 'Movie $index'),
  );
  setUp(() {
    useCase = QueryMoviesUseCase(repository: repo);

    when(
      () => repo.queryMovies(
        query: any(named: 'query'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => movies,
    );
  });

  test(
    'Invokes the correct repository method with the provided params',
    () async {
      const query = 'John Wick';
      const page = 1;
      final results = await useCase(query: query, page: page);

      expect(results, movies);
      verify(
        () => repo.queryMovies(query: query, page: 1),
      ).called(1);
    },
  );
}
