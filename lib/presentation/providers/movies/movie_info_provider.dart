import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

final getMovielInfoProvider =
    StateNotifierProvider<MovieMapNotifiers, Map<String, Movie>>((ref) {
  final fetchOneMovie = ref.watch(movieRepositoryProvider).getMovieId;

  return MovieMapNotifiers(getMovieCallback: fetchOneMovie);
});

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifiers extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovieCallback;

  MovieMapNotifiers({required this.getMovieCallback}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    print('Realizando peticion http');
    final movie = await getMovieCallback(movieId);

    state = {...state, movieId: movie};
  }
}
