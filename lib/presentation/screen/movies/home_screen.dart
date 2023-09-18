import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

import '../../views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  final int indexPage;
  const HomeScreen({super.key, required this.indexPage});

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoriteViews(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: indexPage,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottonNavigationBar(currentIndex: indexPage),
    );
  }
}
