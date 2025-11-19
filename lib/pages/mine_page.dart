import 'package:flutter/material.dart';

import 'about_page.dart';
import 'zali_privacy_page.dart';
import 'zali_terms_page.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      child: Container(
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
                        child: Image.asset(
                          'assets/user_default.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0),
              Text(
                'Zali',
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
              const SizedBox(height: 24),
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
