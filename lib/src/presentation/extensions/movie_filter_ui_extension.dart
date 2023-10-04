import '../../domain/model/movie_filter.dart';

/// Extension that provides UI functionality for [MovieFilter].
extension MovieFilterUIExtension on MovieFilter {
  /// Returns the localization associated with the filter
  String get localization {
    switch (this) {
      case MovieFilter.popular:
        return 'Popular';

      case MovieFilter.upcoming:
        return 'Upcoming';

      case MovieFilter.topRated:
        return 'Top rated';

      case MovieFilter.nowPlaying:
        return 'Now playing';
    }
  }
}
