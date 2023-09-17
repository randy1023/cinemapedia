import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actor_respository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorByMovieProvider =
    StateNotifierProvider<ActorByMovieNotifie, Map<String, List<Actor>>>((ref) {
  final fetchActor = ref.watch(actorRepositoryProvider);
  return ActorByMovieNotifie(getActor: fetchActor.getMovieActor);
});

typedef GetActorCallBack = Future<List<Actor>> Function(String movieId);

class ActorByMovieNotifie extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorCallBack getActor;
  ActorByMovieNotifie({required this.getActor}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final List<Actor> actors = await getActor(movieId);

    state = {...state, movieId: actors};
  }
}







/* class MovieMapNotifiers extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovieCallback;

  MovieMapNotifiers({required this.getMovieCallback}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    print('Realizando peticion http');
    final movie = await getMovieCallback(movieId);

    state = {...state, movieId: movie};
  }
} */
