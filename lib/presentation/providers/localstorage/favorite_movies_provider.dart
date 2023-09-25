import 'package:cinemapedia/domain/repositories/local_storage_respository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

final favoriteMovieProvider =
    StateNotifierProvider<FavoriteMovieNotifier, Map<int, Movie>>((ref) {
  final localStorgeRepository = ref.watch(localRepositoryProvider);

  return FavoriteMovieNotifier(localStorageRepository: localStorgeRepository);
});

class FavoriteMovieNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  FavoriteMovieNotifier({
    required this.localStorageRepository,
  }) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies =
        await localStorageRepository.loadMovie(offset: page * 10, limit: 20);
    page++;

    final tempmovieMap = <int, Movie>{};

    for (final movie in movies) {
      tempmovieMap[movie.id] = movie;
    }

    state = {...state, ...tempmovieMap};

    return movies;
  }

  Future<void> toggledFavorite(Movie movie) async {
    await localStorageRepository.toggledFavorite(movie);

    final bool isMovieInFavorites = state[movie.id] != null;

    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}



/* typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifiers extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovieCallback;

  MovieMapNotifiers({required this.getMovieCallback}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    print('Realizando peticion http');
    final movie = await getMovieCallback(movieId);

    state = {...state, movieId: movie};
  }
} */
