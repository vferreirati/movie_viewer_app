import '../model/movie.dart';
import '../repository/movie_repository.dart';

/// Use case responsible for querying a list of [Movies] based on the provided parameters
class QueryMoviesUseCase {
  final MovieRepository _repository;

  /// Creates a new [QueryMoviesUseCase] instance.
  QueryMoviesUseCase({
    required MovieRepository repository,
  }) : _repository = repository;

  /// Fetches a list of [Movies] that matches the provided `query`.
  ///
  /// Use the `page` parameter to paginate.
  Future<List<Movie>> call({
    required String query,
    int page = 1,
  }) =>
      _repository.queryMovies(
        query: query,
        page: page,
      );
}
