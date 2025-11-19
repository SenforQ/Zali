import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'zali_privacy_page.dart';
import 'zali_terms_page.dart';
import '../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _agreed = false;
  bool _navigating = false;

  void _enterApp() {
    if (!_agreed || _navigating) return;
    setState(() => _navigating = true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ZaliTabScaffold()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/welcome_bg.webp', fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              mediaQuery.padding.top + 40,
              24,
              mediaQuery.padding.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28FF5E),
                      disabledBackgroundColor: const Color(0xFF28FF5E),
                      foregroundColor: Colors.black,
                      disabledForegroundColor: Colors.black.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: _agreed ? _enterApp : null,
                    child: _navigating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Enter App',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: _agreed,
                      onChanged: (value) {
                        setState(() {
                          _agreed = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF28FF5E),
                      side: const BorderSide(color: Colors.white54),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'I have read and agree to the Privacy Policy and User Agreement.',
                            ),
                            TextSpan(
                              text: '\nPrivacy Policy',
                              style: const TextStyle(
                                color: Color(0xFF28FF5E),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ZaliPrivacyPage(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ' · '),
                            TextSpan(
                              text: 'User Agreement',
                              style: const TextStyle(
                                color: Color(0xFF28FF5E),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ZaliTermsPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
