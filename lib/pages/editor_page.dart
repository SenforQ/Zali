import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import '../services/user_profile_service.dart';
import '../services/vip_service.dart';
import 'vip_page.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final List<String> _tagOptions = const [
    'Cardio',
    'HIIT',
    'Yoga',
    'Strength',
    'Mobility',
    'Pilates',
    'Cycling',
    'Running',
  ];
  final List<String> _avatarOptions = const [
    'assets/user_default.webp',
    'assets/rank_1.webp',
    'assets/rank_2.webp',
    'assets/rank_3.webp',
    'assets/rank_4.webp',
    'assets/rank_5.webp',
  ];

  String _avatarPath = 'assets/user_default.webp';
  bool _avatarIsAsset = true;
  final Set<String> _selectedTags = {};
  bool _saving = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await UserProfileService.initializeDefaults();
    final profile = await UserProfileService.loadProfile();
    setState(() {
      _avatarPath = profile.avatarPath;
      _avatarIsAsset = profile.isAssetAvatar;
      _nicknameController.text = profile.nickname;
      _selectedTags
        ..clear()
        ..addAll(profile.tags);
      _loading = false;
    });
  }

  Future<void> _handleSave() async {
    if (_saving) return;

    final isVip = await _checkVipStatus();
    if (!isVip) {
      if (!mounted) return;
      _showVipDialog();
      return;
    }
    setState(() {
      _saving = true;
    });

    final profile = UserProfile(
      avatarPath: _avatarPath,
      isAssetAvatar: _avatarIsAsset,
      nickname: _nicknameController.text.trim().isEmpty
          ? 'Zali'
          : _nicknameController.text.trim(),
      tags: _selectedTags.toList(),
    );

    await UserProfileService.saveProfile(profile);

    if (!mounted) return;
    setState(() {
      _saving = false;
    });
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Profile'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF28FF5E)),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Avatar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAvatarPreview(),
                    const SizedBox(height: 24),
                    const Text(
                      'Nickname',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nicknameController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: const Color(0xFF28FF5E),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF141414),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter your nickname',
                        hintStyle: const TextStyle(color: Color(0xFF777777)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Favorite Training Tags',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _tagOptions.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return ChoiceChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          selectedColor: const Color(0xFF28FF5E),
                          backgroundColor: const Color(0xFF141414),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF28FF5E)
                                  : const Color(0xFF333333),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF28FF5E),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.black),
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvatarPreview() {
    final imageWidget = _avatarIsAsset
        ? Image.asset(
            _avatarPath,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(_avatarPath),
            fit: BoxFit.cover,
          );

    return Center(
      child: GestureDetector(
        onTap: _pickImageFromGallery,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF28FF5E),
                  width: 2,
                ),
              ),
              child: ClipOval(child: imageWidget),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF28FF5E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return GridView.builder(
      itemCount: _avatarOptions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final avatar = _avatarOptions[index];
        final isSelected = _avatarIsAsset && avatar == _avatarPath;
        return GestureDetector(
          onTap: () {
            setState(() {
              _avatarPath = avatar;
              _avatarIsAsset = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF28FF5E) : const Color(0xFF333333),
                width: isSelected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                avatar,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
    );
    if (picked == null) return;

    final extension = picked.name.contains('.')
        ? picked.name.split('.').last
        : 'jpg';
    final fileName =
        'avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final targetFile = await UserProfileService.createAvatarFile(fileName);
    await File(picked.path).copy(targetFile.path);

    if (!mounted) return;
    setState(() {
      _avatarPath = targetFile.path;
      _avatarIsAsset = false;
    });
  }

  Future<bool> _checkVipStatus() async {
    final isActive = await VipService.isVipActive();
    final isExpired = await VipService.isVipExpired();
    if (isActive && !isExpired) {
      return true;
    }
    if (isActive && isExpired) {
      await VipService.deactivateVip();
    }
    return false;
  }

  void _showVipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.diamond, color: Color(0xFF28FF5E)),
            SizedBox(width: 8),
            Text('VIP Required', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Profile editing is available for VIP users only.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VipPage()),
              );
            },
            child: const Text(
              'Go',
              style: TextStyle(
                color: Color(0xFF28FF5E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

