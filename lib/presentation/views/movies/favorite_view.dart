import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';

class FavoriteViews extends ConsumerStatefulWidget {
  final int page = 0;
  const FavoriteViews({
    super.key,
  });

  @override
  FavoriteViewsState createState() => FavoriteViewsState();
}

class FavoriteViewsState extends ConsumerState<FavoriteViews> {
  bool isLastPage = false;

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;

    final movies =
        await ref.read(favoriteMovieProvider.notifier).loadNextPage();

    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final moviesMap = ref.watch(favoriteMovieProvider);
    final movies = moviesMap.values.toList();

    if (movies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline_sharp,
              size: 60,
              color: colors.primary,
            ),
            Text(
              'ohh no!!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            const Text(
              'No tienes peliculas favoritas',
              style: TextStyle(fontSize: 20, color: Colors.black45),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.tonal(
                onPressed: () => context.go('/home/0'),
                child: const Text('Empieza agregar'))
          ],
        ),
      );
    }

    return Scaffold(
        body: SizedBox(
      height: size.height * 1,
      child: MovieMasonry(
        loadNextPage: loadNextPage,
        movies: movies,
      ),
    ));
  }
}
