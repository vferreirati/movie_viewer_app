import '../model/movie.dart';

/// Definition of the MovieRepository.
abstract class MovieRepository {
  /// Retrieves a list of movies with the provided parameters.
  ///
  /// Use the `page` parameter to paginate.
  Future<List<Movie>> listMovies({
    required String filter,
    int page = 1,
  });

  /// Retrieves a list of movies based on the provided query.
  ///
  /// Use the `page` parameter to paginate.
  Future<List<Movie>> queryMovies({
    required String query,
    int page = 1,
  });
}
