import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZaliPrivacyPage extends StatefulWidget {
  const ZaliPrivacyPage({super.key});

  @override
  State<ZaliPrivacyPage> createState() => _ZaliPrivacyPageState();
}

class _ZaliPrivacyPageState extends State<ZaliPrivacyPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          'https://www.privacypolicies.com/live/ac650fd4-d968-4e42-8353-c713aa92dc3a',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox.expand(child: WebViewWidget(controller: _controller)),
      ),
    );
  }
}
