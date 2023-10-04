/// Enum that represents all possible [Movie] filters
enum MovieFilter {
  /// Popular movies
  popular('popular'),

  /// Upcoming movies
  upcoming('upcoming'),

  /// Top rated movies
  topRated('top_rated'),

  /// Now playing movies
  nowPlaying('now_playing');

  const MovieFilter(this.dtoValue);
  final String dtoValue;
}
