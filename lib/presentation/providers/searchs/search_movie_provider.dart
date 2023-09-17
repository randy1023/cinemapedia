import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider).searchMovie;

  return SearchMoviesNotifier(searchMovie: movieRepository, ref: ref);
});

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  SearchMovieCallback searchMovie;
  final Ref ref;
  SearchMoviesNotifier({required this.searchMovie, required this.ref})
      : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovie(query);

    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;

    return movies;
  }
}
