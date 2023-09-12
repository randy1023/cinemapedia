import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/movieDB/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/movieDB/movie_moviedb.dart';

class MovieMappars {
  static Movie movieDBToEntity(MovieMovieDB movieDB) => Movie(
        adult: movieDB.adult,
        backdropPath: movieDB.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
            : 'https://1.bp.blogspot.com/-bT_QdG9WCVo/YRhpCso7b4I/AAAAAAAA3kg/H-FxoRFU_YMAH7__NcnOfZnL38Syl1f5gCLcBGAsYHQ/s865/404%2Berror%2Bpage.png',
        genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
        id: movieDB.id,
        originalLanguage: movieDB.originalLanguage,
        originalTitle: movieDB.originalTitle,
        overview: movieDB.overview,
        popularity: movieDB.popularity,
        posterPath: movieDB.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
            : 'no-poster',
        releaseDate: movieDB.releaseDate,
        title: movieDB.title,
        video: movieDB.video,
        voteAverage: movieDB.voteAverage,
        voteCount: movieDB.voteCount,
      );

  static Movie movieDetailsEntity(MovieDetails movieDetails) => Movie(
        adult: movieDetails.adult,
        backdropPath: movieDetails.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500${movieDetails.backdropPath}'
            : 'https://1.bp.blogspot.com/-bT_QdG9WCVo/YRhpCso7b4I/AAAAAAAA3kg/H-FxoRFU_YMAH7__NcnOfZnL38Syl1f5gCLcBGAsYHQ/s865/404%2Berror%2Bpage.png',
        genreIds: movieDetails.genres.map((e) => e.name).toList(),
        id: movieDetails.id,
        originalLanguage: movieDetails.originalLanguage,
        originalTitle: movieDetails.originalTitle,
        overview: movieDetails.overview,
        popularity: movieDetails.popularity,
        posterPath: movieDetails.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}'
            : 'no-poster',
        title: movieDetails.title,
        video: movieDetails.video,
        voteAverage: movieDetails.voteAverage,
        voteCount: movieDetails.voteCount,
      );
}
