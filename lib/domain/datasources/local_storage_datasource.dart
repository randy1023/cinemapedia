import '../entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<void> toggledFavorite(Movie movie);

  Future<bool> isMovieFavorite(int movieId);

  Future<List<Movie>> loadMovie({int limit = 10, offset = 0});
}
