import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class UserProfileService {
  UserProfileService._();

  static const _avatarKey = 'user_profile_avatar';
  static const _nicknameKey = 'user_profile_nickname';
  static const _tagsKey = 'user_profile_tags';

  static const _defaultAvatar = 'assets/user_default.webp';
  static const _defaultNickname = 'Zali';
  static const _customAvatarFolder = 'avatars';

  static Future<void> initializeDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_avatarKey)) {
      await prefs.setString(_avatarKey, _defaultAvatar);
    }
    if (!prefs.containsKey(_nicknameKey)) {
      await prefs.setString(_nicknameKey, _defaultNickname);
    }
    if (!prefs.containsKey(_tagsKey)) {
      await prefs.setStringList(_tagsKey, const []);
    }
  }

  static Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final storedAvatar = prefs.getString(_avatarKey) ?? _defaultAvatar;
    final nickname = prefs.getString(_nicknameKey) ?? _defaultNickname;
    final tags = prefs.getStringList(_tagsKey) ?? const [];

    if (storedAvatar.startsWith('assets/')) {
      return UserProfile(
        avatarPath: storedAvatar,
        isAssetAvatar: true,
        nickname: nickname,
        tags: List<String>.from(tags),
      );
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final absolutePath = '${docsDir.path}/$storedAvatar';
    return UserProfile(
      avatarPath: absolutePath,
      isAssetAvatar: false,
      nickname: nickname,
      tags: List<String>.from(tags),
    );
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    String storedAvatar = profile.avatarPath;

    if (!profile.isAssetAvatar) {
      final docsDir = await getApplicationDocumentsDirectory();
      final docsPath = docsDir.path;
      if (storedAvatar.startsWith(docsPath)) {
        storedAvatar = storedAvatar.substring(docsPath.length);
        if (storedAvatar.startsWith('/')) {
          storedAvatar = storedAvatar.substring(1);
        }
      }
    }

    await prefs.setString(_avatarKey, storedAvatar);
    await prefs.setString(_nicknameKey, profile.nickname);
    await prefs.setStringList(_tagsKey, profile.tags);
  }

  static Future<File> createAvatarFile(String fileName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory('${docsDir.path}/$_customAvatarFolder');
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }
    return File('${avatarDir.path}/$fileName');
  }
}

