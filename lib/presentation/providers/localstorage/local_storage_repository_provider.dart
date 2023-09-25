import 'package:cinemapedia/infrastructure/datasources/isar_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/isar_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localRepositoryProvider = Provider((ref) {
  return IsarRespositoryImpl(isarDatasource: IsarDatasourceImpl());
});
