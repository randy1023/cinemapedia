import 'package:cinemapedia/config/constants/enviroments.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mappers.dart';
import 'package:cinemapedia/infrastructure/models/movieDB/movieDB_response.dart';
import 'package:dio/dio.dart';

/* En este codigo se hace una clase que extiende de el datasource aqui es donde se utiliza la regra de negocio de la clase abstracta
se hace la consulta y se obtiene las peliculas */

class MovieDbDatasourceImpl extends MovieDatasources {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDBkey,
      'language': 'es-MX',
    },
  ));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});

    final movieDBREsponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBREsponse.results
        .where((movieDB) => movieDB.posterPath != 'no-poster')
        .map((movieDB) => MovieMappars.movieDBToEntity(movieDB))
        .toList();
    return movies;
  }
}
