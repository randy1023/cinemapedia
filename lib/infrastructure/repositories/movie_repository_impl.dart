import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';

// Aqui se manda a llamar directamente el datasource abstracto
class MovieRepositoryImpl extends MovieRepository {
  final MovieDatasources movieDatasources;

  MovieRepositoryImpl(this.movieDatasources);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return movieDatasources.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return movieDatasources.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getToRate({int page = 1}) {
    return movieDatasources.getToRate(page: page);
  }

  @override
  Future<List<Movie>> getUpComing({int page = 1}) {
    return movieDatasources.getUpComing(page: page);
  }

  @override
  Future<Movie> getMovieId(String id) {
    return movieDatasources.getMovieId(id);
  }

  @override
  Future<List<Movie>> searchMovie(String query) {
    return movieDatasources.searchMovie(query);
  }
}
