import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider solo es inmutable es de solo lectura
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MovieDbDatasourceImpl());
});
