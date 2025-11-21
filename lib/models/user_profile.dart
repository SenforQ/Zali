class UserProfile {
  final String avatarPath;
  final bool isAssetAvatar;
  final String nickname;
  final List<String> tags;

  const UserProfile({
    required this.avatarPath,
    required this.isAssetAvatar,
    required this.nickname,
    required this.tags,
  });

  UserProfile copyWith({
    String? avatarPath,
    bool? isAssetAvatar,
    String? nickname,
    List<String>? tags,
  }) {
    return UserProfile(
      avatarPath: avatarPath ?? this.avatarPath,
      isAssetAvatar: isAssetAvatar ?? this.isAssetAvatar,
      nickname: nickname ?? this.nickname,
      tags: tags ?? this.tags,
    );
  }
}

