import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_respository.dart';

class IsarRespositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource isarDatasource;

  IsarRespositoryImpl({required this.isarDatasource});

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return isarDatasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovie({int limit = 10, offset = 0}) {
    return isarDatasource.loadMovie(limit: limit, offset: offset);
  }

  @override
  Future<void> toggledFavorite(Movie movie) {
    return isarDatasource.toggledFavorite(movie);
  }
}
