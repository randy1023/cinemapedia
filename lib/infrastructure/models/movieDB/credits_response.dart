import 'package:cinemapedia/infrastructure/models/movieDB/cast_details.dart';

class CreditsResponse {
  final int id;
  final List<CastDetails> cast;
  final List<CastDetails> crew;

  CreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CreditsResponse.fromJson(Map<String, dynamic> json) =>
      CreditsResponse(
        id: json["id"],
        cast: List<CastDetails>.from(json["cast"].map((x) => CastDetails.fromJson(x))),
        crew: List<CastDetails>.from(json["crew"].map((x) => CastDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}



/* enum Department {
    ACTING,
    ART,
    CAMERA,
    COSTUME_MAKE_UP,
    CREW,
    DIRECTING,
    EDITING,
    LIGHTING,
    PRODUCTION,
    SOUND,
    VISUAL_EFFECTS,
    WRITING
} */

/* final departmentValues = EnumValues({
    "Acting": Department.ACTING,
    "Art": Department.ART,
    "Camera": Department.CAMERA,
    "Costume & Make-Up": Department.COSTUME_MAKE_UP,
    "Crew": Department.CREW,
    "Directing": Department.DIRECTING,
    "Editing": Department.EDITING,
    "Lighting": Department.LIGHTING,
    "Production": Department.PRODUCTION,
    "Sound": Department.SOUND,
    "Visual Effects": Department.VISUAL_EFFECTS,
    "Writing": Department.WRITING
}); */

/* class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    } }*/

