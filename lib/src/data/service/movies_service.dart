import 'package:dio/dio.dart';

import '../dtos/movie_page_dto.dart';

/// Service class responsible for interacting with the [Movie] backend service
class MovieService {
  final Dio _client;

  /// Creates a new [MovieService] instance.
  MovieService({
    required Dio client,
  }) : _client = client;

  /// Retrieves a list of movies with the provided parameters.
  ///
  /// Use the `page` parameter to paginate.
  Future<MoviePageDTO> listMovies({
    required String filter,
    int page = 1,
  }) async {
    final response = await _client.get(
      'movie/$filter',
      queryParameters: {
        'page': page,
      },
    );

    return MoviePageDTO.fromJson(response.data);
  }

  /// Retrieves a list of movies based on the provided query.
  ///
  /// Use the `page` parameter to paginate.
  Future<MoviePageDTO> queryMovies({
    required String query,
    int page = 1,
  }) async {
    final response = await _client.get(
      'search/movie',
      queryParameters: {
        'query': query,
        'page': page,
      },
    );

    return MoviePageDTO.fromJson(response.data);
  }
}
