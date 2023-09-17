import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actor_repository.dart';



class ActorsRepositoryImpl extends ActorsRepository{

  final ActorsDatasource datasource;

  ActorsRepositoryImpl(this.datasource);
  @override
  Future<List<Actor>> getMovieActor(String movieId)async {
    return datasource.getMovieActor(movieId);
  }
  
}
