import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_app/src/domain/model/movie.dart';
import 'package:tmdb_app/src/domain/repository/movie_repository.dart';
import 'package:tmdb_app/src/domain/use_case/list_movies_use_case.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late ListMoviesUseCase useCase;
  late var repo = MockMovieRepository();
  final movies = List.generate(
    5,
    (index) => Movie(title: 'Movie $index'),
  );
  setUp(() {
    useCase = ListMoviesUseCase(repository: repo);

    when(
      () => repo.listMovies(
        filter: any(named: 'filter'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => movies,
    );
  });

  test(
    'Invokes the correct repository method with the provided params',
    () async {
      const filter = 'popular';
      const page = 1;
      final results = await useCase(filter: filter, page: page);

      expect(results, movies);
      verify(
        () => repo.listMovies(filter: filter, page: 1),
      ).called(1);
    },
  );
}
