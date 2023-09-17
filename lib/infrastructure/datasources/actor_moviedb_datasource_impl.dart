import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mappers.dart';
import 'package:cinemapedia/infrastructure/models/models.dart';
import 'package:dio/dio.dart';

import '../../config/constants/enviroments.dart';

class ActorDatasourceimpl extends ActorsDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDBkey,
      'language': 'es-MX',
    },
  ));
  List<Actor> _jsonToMovies(Map<String, dynamic> json) {
    final creditsResponse = CreditsResponse.fromJson(json);

    final List<Actor> cast = creditsResponse.cast
        .where((cast) => cast.profilePath != 'no-poster')
        .map((cast) => ActorMapper.getMovieActorsEntity(cast))
        .toList();
    return cast;
  }

  @override
  Future<List<Actor>> getMovieActor(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToMovies(response.data);
  }
}
