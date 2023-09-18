import 'package:flutter/material.dart';

class FavoriteViews extends StatelessWidget {
  const FavoriteViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite views'),
      ),
      body: const Center(
        child: Text('favorite'),
      ),
    );
  }
}
