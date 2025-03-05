class Cast {
  List<Actor> actores = [];

  Cast.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    }
  }
}

class Actor {
  final int castId;
  final String character;
  final String creditId;
  final int gender;
  final int id;
  final String name;
  final int order;
  final String profilePath;

  Actor({
    required this.castId,
    required this.character,
    required this.creditId,
    required this.gender,
    required this.id,
    required this.name,
    required this.order,
    required this.profilePath,
  });

  factory Actor.fromJsonMap(Map<String, dynamic> json) {
    return Actor(
      castId: json['cast_id'] ?? 0,
      character: json['character'] ?? 'Sin personaje',
      creditId: json['credit_id'] ?? '',
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Desconocido',
      order: json['order'] ?? 0,
      profilePath: json['profile_path'] ?? '',
    );
  }

  String getFoto() {
    if (profilePath.isEmpty) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
