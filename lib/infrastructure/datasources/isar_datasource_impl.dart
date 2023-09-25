import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasourceImpl extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasourceImpl() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [MovieSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoritemovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    // ignore: unnecessary_null_comparison
    return isFavoritemovie != null;
  }

  @override
  Future<List<Movie>> loadMovie({int limit = 20, offset = 0}) async {
    final isar = await db;

    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggledFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovies =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovies != null) {
      //borrar
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovies.isarId!));
      return;
    }

    //insert
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
