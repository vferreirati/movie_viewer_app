import '../model/movie.dart';
import '../repository/movie_repository.dart';

/// Use case responsible for fetching a list of [Movies] based on the provided parameters
class ListMoviesUseCase {
  final MovieRepository _repository;

  /// Creates a new [ListMoviesUseCase] instance.
  ListMoviesUseCase({
    required MovieRepository repository,
  }) : _repository = repository;

  /// Fetches a list of [Movies] with the provided `filter`.
  ///
  /// Use the `page` parameter to paginate.
  Future<List<Movie>> call({
    required String filter,
    int page = 1,
  }) =>
      _repository.listMovies(
        filter: filter,
        page: page,
      );
}
