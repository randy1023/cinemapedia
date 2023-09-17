import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

import '../../widgets/widgets.dart';


class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(getMoviesPopularProvider.notifier).loadNextPage();
    ref.read(getMoviesToRateProvider.notifier).loadNextPage();
    ref.read(getMoviesUpComingProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const  FullScreenLoading();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideShowProvider);
    final popularMovies = ref.watch(getMoviesPopularProvider);
    final toRateMovies = ref.watch(getMoviesToRateProvider);
    final upComingMovies = ref.watch(getMoviesUpComingProvider);
    
    return Visibility(
      visible: !initialLoading,
      child: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: Container(
              color: Colors.white,
              child: const Flexible(
                fit: FlexFit.tight,
                child: CustomAppbar(),
              )),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              //const CustomAppbar(),
              MoviesSlidesShow(movies: slideShowMovies),
              MovieHorizontalListView(
                movies: nowPlayingMovies,
                title: 'En cines',
                subTitle: 'Lunes 20',
                loadNextPage: () {
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListView(
                movies: upComingMovies,
                title: 'Proximamente',
                subTitle: 'En este mes',
                loadNextPage: () {
                  ref.read(getMoviesUpComingProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListView(
                movies: popularMovies,
                title: 'Populares',
                subTitle: 'Todos los tiempos',
                loadNextPage: () {
                  ref.read(getMoviesPopularProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListView(
                movies: toRateMovies,
                title: 'Mejores calificadas',
                subTitle: 'Desde siempre',
                loadNextPage: () {
                  ref.read(getMoviesToRateProvider.notifier).loadNextPage();
                },
              ),
              const SizedBox(
                height: 25,
              )
            ],
          );
        }, childCount: 10))
      ]),
    );
  }
}
