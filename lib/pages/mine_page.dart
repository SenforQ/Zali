import 'dart:io';

import 'package:flutter/material.dart';

import 'about_page.dart';
import 'editor_page.dart';
import 'vip_page.dart';
import 'wallet_page.dart';
import 'zali_privacy_page.dart';
import 'zali_terms_page.dart';
import '../services/user_profile_service.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String _avatarPath = 'assets/user_default.webp';
  bool _isAssetAvatar = true;
  String _nickname = 'Zali';
  List<String> _tags = const [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await UserProfileService.initializeDefaults();
    final profile = await UserProfileService.loadProfile();
    if (!mounted) return;
    setState(() {
      _avatarPath = profile.avatarPath;
      _isAssetAvatar = profile.isAssetAvatar;
      _nickname = profile.nickname.isEmpty ? 'Zali' : profile.nickname;
      _tags = profile.tags;
    });
  }

  Future<void> _openEditor() async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditorPage()),
    );
    if (updated == true) {
      await _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final actionButtonWidth = (screenWidth - 40 - 13) / 2;

    const actionCells = [
      ('assets/icon_me_contract.webp', 'User Contract'),
      ('assets/icon_me_policy.webp', 'Privacy Policy'),
      ('assets/icon_me_us.webp', 'About us'),
    ];

    void handleCellTap(String title) {
      if (title == 'Privacy Policy') {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ZaliPrivacyPage()));
      } else if (title == 'User Contract') {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ZaliTermsPage()));
      } else if (title == 'About us') {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AboutPage()));
      }
    }

    return Container(
      color: const Color(0xFF0A0A0A),
      child: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 340,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 280,
                      child: Image.asset(
                        'assets/mine_top_bg.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 222,
                      child: GestureDetector(
                        onTap: _openEditor,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF999999),
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                            child: _isAssetAvatar
                                ? Image.asset(
                                    _avatarPath,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_avatarPath),
                                    fit: BoxFit.cover,
                                  ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF28FF5E),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0),
              Text(
                _nickname,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Train every day and continuously improve yourself💪.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF999999),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MineActionButton(
                      width: actionButtonWidth,
                      backgroundColor: const Color(0xFF141414),
                      primaryColor: const Color(0xFF28FF5E),
                      label: 'Wallet',
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WalletPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 13),
                    _MineActionButton(
                      width: actionButtonWidth,
                      backgroundColor: const Color(0xFF141414),
                      primaryColor: const Color(0xFF28FF5E),
                      label: 'VIP',
                      icon: Icons.diamond_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const VipPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF28FF5E),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (_tags.isNotEmpty) const SizedBox(height: 24),
              ...actionCells.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => handleCellTap(item.$2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF1E1E1E)),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            item.$1,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.$2,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MineActionButton extends StatelessWidget {
  const _MineActionButton({
    required this.width,
    required this.backgroundColor,
    required this.primaryColor,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final double width;
  final Color backgroundColor;
  final Color primaryColor;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: 64,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
