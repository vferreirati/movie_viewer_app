import '../../domain/model/movie.dart';
import '../../domain/repository/movie_repository.dart';
import '../mapping/movie_dto_mapping.dart';
import '../service/movies_service.dart';

/// Concrete implementation of the [MovieRepository]
///
/// Responsible fetching [Movie] related data
class MovieRepositoryImpl implements MovieRepository {
  final MovieService _service;

  /// Creates a new [MovieRepositoryImpl] instance.
  MovieRepositoryImpl({
    required MovieService service,
  }) : _service = service;

  /// Retrieves a list of movies with the provided parameters.
  ///
  /// Use the `page` parameter to paginate.
  @override
  Future<List<Movie>> listMovies({
    required String filter,
    int page = 1,
  }) async {
    final dto = await _service.listMovies(
      filter: filter,
      page: page,
    );

    return dto.results?.map((e) => e.toMovie()).toList() ?? [];
  }

  /// Retrieves a list of movies based on the provided query.
  ///
  /// Use the `page` parameter to paginate.
  @override
  Future<List<Movie>> queryMovies({
    required String query,
    int page = 1,
  }) async {
    final dto = await _service.queryMovies(
      query: query,
      page: page,
    );

    return dto.results?.map((e) => e.toMovie()).toList() ?? [];
  }
}
