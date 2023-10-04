import 'package:equatable/equatable.dart';

/// Model that represents a single movie.
class Movie extends Equatable {
  /// Title of the movie
  final String title;

  /// Description of the movie
  final String description;

  /// Complete URL of the movie poster
  final String posterURL;

  /// The rating score of the movie
  final double score;

  /// Creates a new [Movie] instance.
  const Movie({
    this.title = '',
    this.description = '',
    this.posterURL = '',
    this.score = 0.0,
  });

  /// Creates a new instance with the provided parameters
  Movie copyWith({
    String? title,
    String? description,
    String? posterURL,
    double? score,
  }) {
    return Movie(
      title: title ?? this.title,
      description: description ?? this.description,
      posterURL: posterURL ?? this.posterURL,
      score: score ?? this.score,
    );
  }

  @override
  List<Object> get props => [
        title,
        description,
        posterURL,
        score,
      ];
}
