import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import '../../../domain/entities/movie.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.read(getMovielInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(getMovielInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) => _MovieDetails(
              movie: movie,
            ),
          ))
        ],
      ),
    );
  }
}

final isfavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localRepository = ref.watch(localRepositoryProvider);

  return localRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});
/* https://inspect.isar.dev/3.1.0+1/#/44695/86ly7D-MPvw */
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFavoritefuture = ref.watch(isfavoriteProvider(movie.id));
    return SliverAppBar(
      actions: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                /* await ref.read(localRepositoryProvider).toggledFavorite(movie); */
                  await ref.read(favoriteMovieProvider.notifier).toggledFavorite(movie);
                ref.invalidate(isfavoriteProvider(movie.id));
              },
              icon: isFavoritefuture.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                )),
                data: (isFavorite) => isFavorite
                    ? const Icon(Icons.favorite_outlined, color: Colors.red)
                    : const Icon(Icons.favorite_border_outlined),
                error: (_, __) => throw UnimplementedError(),
              ),
            ))
      ],
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        /* title: Text(
          movie.title,
          style: const TextStyle(fontSize: 17),
          textAlign: TextAlign.center,
        ), */
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeInRight(child: child);
                },
              ),
            ),
            const _CustomSizeBox(
                stops: [0.7, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                color: [Colors.transparent, Colors.black38]),
            const _CustomSizeBox(
              stops: [0.0, 0.3],
              begin: Alignment.topLeft,
              color: [Colors.black38, Colors.transparent],
              end: Alignment.bottomLeft,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomSizeBox extends StatelessWidget {
  final List<double>? stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<Color> color;
  const _CustomSizeBox(
      {required this.stops,
      required this.begin,
      required this.end,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          stops: stops,
          colors: color,
        ),
      )),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final titleStyle = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: titleStyle.titleLarge),
                    Text(movie.overview),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ))
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 50)
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorByMovie = ref.watch(actorByMovieProvider)[movieId];

    if (actorByMovie == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actorByMovie.length,
          itemBuilder: (context, index) {
            final actor = actorByMovie[index];

            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        actor.profilePath,
                        height: 180,
                        width: 135,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    actor.name,
                    maxLines: 2,
                  ),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            );
          },
        ));
  }
}
