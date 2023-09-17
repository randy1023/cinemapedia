import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasources{

 Future<List<Movie>> getNowPlaying({int page = 1});

 Future<List<Movie>> getPopular({int page = 1});

 Future<List<Movie>> getUpComing({int page = 1});

 Future<List<Movie>> getToRate({int page = 1});

 Future<Movie> getMovieId(String id );
  
}


