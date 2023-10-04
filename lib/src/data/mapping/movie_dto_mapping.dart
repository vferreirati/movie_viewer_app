import '../../common/constants.dart';
import '../../domain/model/movie.dart';
import '../dtos/movie_dto.dart';

/// Extension that provides DTO mappings functionalities.
extension MovieDTOMapping on MovieDTO {
  /// Maps into a [Movie].
  Movie toMovie() => Movie(
        title: title ?? '',
        description: overview ?? '',
        posterURL:
            posterPath == null ? '' : '${Constants.imageBaseUrl}$posterPath',
        score: voteAverage ?? 0.0,
      );
}
