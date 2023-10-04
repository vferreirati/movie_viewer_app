import 'movie_dto.dart';

/// Data transfer object that wraps the movie response
class MoviePageDTO {
  /// The current page of data
  final int? page;

  /// The list of movies retrieved.
  final List<MovieDTO>? results;

  /// Creates a new [MoviePageDTO] instance.
  MoviePageDTO({
    this.page,
    this.results,
  });

  /// Maps the instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results?.map((x) => x.toJson()).toList(),
    };
  }

  /// Creates a new instance from a JSON map
  factory MoviePageDTO.fromJson(Map<String, dynamic> map) {
    return MoviePageDTO(
      page: map['page']?.toInt(),
      results: map['results'] != null
          ? List<MovieDTO>.from(
              map['results']?.map((x) => MovieDTO.fromJson(x)),
            )
          : null,
    );
  }
}
