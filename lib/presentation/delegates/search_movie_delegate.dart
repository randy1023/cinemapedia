import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/humans_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SerachMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SerachMovieCallback serachMovieCallback;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _deBounceTimer;

  SearchMovieDelegate(
      {required this.initialMovies,
      super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.serachMovieCallback});

  void _clearStream() {
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_deBounceTimer?.isActive ?? false) _deBounceTimer?.cancel();

    _deBounceTimer = Timer(const Duration(milliseconds: 500), () async {
      /*  if (query.isEmpty) {
        debouncedMovies.add([]);
        return;
      } */
      final movie = await serachMovieCallback(query);
      initialMovies = movie;
      debouncedMovies.add(movie);
      isLoadingStream.add(false);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              infinite: true,
              delay: const Duration(milliseconds: 500),
              child: IconButton(
                  onPressed: () => query = '',
                  icon: const Icon(
                    Icons.change_circle_rounded,
                    color: Colors.black,
                  )),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black,
                )),
          );
        },
      )
    ];
  }

  StreamBuilder<List<Movie>> _buildResultsAndSuggestion() {
    return StreamBuilder(
      //future: serachMovieCallback(query)
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                _clearStream();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_outlined,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestion();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestion();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2));
                    }
                    return FadeInDown(child: child);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      style: titleStyle.titleMedium,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star_half_outlined,
                            color: Colors.yellow.shade700),
                        const SizedBox(width: 5),
                        Text(
                          HumansFormat.number(movie.voteAverage, 1),
                          style: titleStyle.bodyMedium!
                              .copyWith(color: Colors.yellow.shade700),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    (movie.overview.length > 100)
                        ? Text('${movie.overview.substring(0, 100)}...')
                        : Text(movie.overview)
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
