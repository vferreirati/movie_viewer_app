/// Data transfer object that represents a single movie.
class MovieDTO {
  /// Title of the movie
  final String? title;

  /// Description/overview of the movie
  final String? overview;

  /// Path of the image poster of this movie
  ///
  /// It is not a complete URL.
  final String? posterPath;

  /// The average score of this movie.
  final double? voteAverage;

  /// The release date of the movie.
  final String? releaseDate;

  /// Creates a new [MovieDTO] instance.
  MovieDTO({
    this.title,
    this.overview,
    this.voteAverage,
    this.posterPath,
    this.releaseDate,
  });

  /// Maps the instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'overview': overview,
      'vote_average': voteAverage,
      'poster_path': posterPath,
      'release_date': posterPath,
    };
  }

  /// Creates a new instance from a JSON map
  factory MovieDTO.fromJson(Map<String, dynamic> map) {
    return MovieDTO(
      title: map['title'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      voteAverage: map['vote_average']?.toDouble(),
      releaseDate: map['release_date'],
    );
  }
}
