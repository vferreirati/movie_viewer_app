import '../list/movies_cubit.dart';

/// Extension that provides UI functionality for [MoviesError].
extension MovieErrorUIExtension on MoviesError {
  /// Returns the localization associated with the error
  String get localization {
    switch (this) {
      case MoviesError.network:
        return 'Please check your internet connection';

      case MoviesError.generic:
        return 'Something went wrong';
    }
  }
}
