/// Actor/person entry returned from TMDB credits for a movie detail.
class CastMember {
  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final int id;
  final String name;
  final String character;
  final String? profilePath;
}
