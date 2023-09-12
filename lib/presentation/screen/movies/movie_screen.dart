import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        slivers: [_CustomSliverAppBar(movie: movie)],
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 17),
          textAlign: TextAlign.center,
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
          
            const _CustomSizeBox(
                stops: [0.7, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                color: [Colors.transparent, Colors.black87]),
            const _CustomSizeBox(
              stops: [0.0, 0.3],
              begin: Alignment.topLeft,
              color: [Colors.black87, Colors.transparent],
              end: Alignment.bottomCenter,
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

