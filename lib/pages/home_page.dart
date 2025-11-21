import 'package:flutter/material.dart';

import 'cardio_page.dart';
import 'recovery_page.dart';
import 'strength_page.dart';
import 'vip_page.dart';
import '../services/vip_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedType = 'recovery'; // 默认选中 recovery
  bool _isVipActive = false;

  final List<Map<String, String>> _workoutTypes = [
    {'key': 'cardio', 'name': 'Cardio'},
    {'key': 'recovery', 'name': 'Recovery'},
    {'key': 'strength', 'name': 'Strength'},
  ];

  String _getImagePath(String key) {
    final suffix = _selectedType == key ? '_s' : '';
    return 'assets/home_${key}${suffix}.webp';
  }

  @override
  void initState() {
    super.initState();
    _loadVipStatus();
  }

  Future<void> _loadVipStatus() async {
    final isActive = await VipService.isVipActive();
    final isExpired = await VipService.isVipExpired();

    if (isActive && isExpired) {
      await VipService.deactivateVip();
    }

    if (!mounted) return;
    setState(() {
      _isVipActive = isActive && !isExpired;
    });
  }

  void _navigateToSelectedPage() {
    Widget page;
    switch (_selectedType) {
      case 'cardio':
        page = const CardioPage();
        break;
      case 'strength':
        page = const StrengthPage();
        break;
      case 'recovery':
      default:
        page = const RecoveryPage();
        break;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _handleConfirmTap() async {
    final requiresVip = _selectedType == 'cardio' || _selectedType == 'strength';
    if (requiresVip) {
      await _loadVipStatus();
    }

    if (requiresVip && !_isVipActive) {
      if (!mounted) return;
      _showVipDialog();
      return;
    }

    if (!mounted) return;
    _navigateToSelectedPage();
  }

  void _showVipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(
              Icons.diamond,
              color: Color(0xFF28FF5E),
            ),
            SizedBox(width: 8),
            Text(
              'VIP Feature',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          'This workout type is available for VIP members only.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF888888)),
            ),
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
              style: TextStyle(color: Color(0xFF28FF5E), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    final requiresVip = _selectedType == 'cardio' || _selectedType == 'strength';

    return Container(
      color: const Color(0xFF0A0A0A),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Image.asset(
                'assets/home_bg.webp',
                fit: BoxFit.cover,
                width: screenWidth,
                height: screenHeight,
              ),
            ),
            Positioned(
              bottom: bottomPadding + 24,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Your Style',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose a workout type by your fitness goals, start effective training.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF999999),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _workoutTypes.map((type) {
                        final isSelected = _selectedType == type['key'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = type['key']!;
                            });
                          },
                          child: SizedBox(
                            width: 100,
                            height: 120,
                            child: Image.asset(
                              _getImagePath(type['key']!),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 120,
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _handleConfirmTap,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF28FF5E),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (requiresVip)
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.diamond,
                                  color: Color(0xFF28FF5E),
                                  size: 18,
                                ),
                              ),
                            Text(
                              'Confirm',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
    );
  }
}
