import 'package:movie_vault/features/movies/domain/entities/cast_member.dart';

class CastMemberModel extends CastMember {
  const CastMemberModel({
    required super.id,
    required super.name,
    required super.character,
    required super.profilePath,
  });

  factory CastMemberModel.fromJson(Map<dynamic, dynamic> json) {
    return CastMemberModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }
}
