import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/movieDB/cast_details.dart';

class ActorMapper {
  static Actor getMovieActorsEntity(CastDetails castDetails) => Actor(
        id: castDetails.id,
        name: castDetails.name,
        profilePath: castDetails.profilePath != ''
            ? 'https://image.tmdb.org/t/p/w500${castDetails.profilePath}'
            : 'https://1.bp.blogspot.com/-bT_QdG9WCVo/YRhpCso7b4I/AAAAAAAA3kg/H-FxoRFU_YMAH7__NcnOfZnL38Syl1f5gCLcBGAsYHQ/s865/404%2Berror%2Bpage.png',
        character: castDetails.character,
      );
}
