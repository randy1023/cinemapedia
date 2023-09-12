import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoremovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoremovies: fetchMoremovies);
});

final getMoviesPopularProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoremovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(fetchMoremovies: fetchMoremovies);
});

final getMoviesToRateProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoremovies = ref.watch(movieRepositoryProvider).getToRate;
  return MoviesNotifier(fetchMoremovies: fetchMoremovies);
});

final getMoviesUpComingProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoremovies = ref.watch(movieRepositoryProvider).getUpComing;
  return MoviesNotifier(fetchMoremovies: fetchMoremovies);
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isloading = false;
  MovieCallback fetchMoremovies;
  MoviesNotifier({required this.fetchMoremovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isloading) return;

    isloading = true;
    currentPage++;

    final List<Movie> movies = await fetchMoremovies(page: currentPage);

    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 500));
    isloading = false;
  }
}
