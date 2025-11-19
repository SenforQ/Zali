import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZaliTermsPage extends StatefulWidget {
  const ZaliTermsPage({super.key});

  @override
  State<ZaliTermsPage> createState() => _ZaliTermsPageState();
}

class _ZaliTermsPageState extends State<ZaliTermsPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          'https://www.privacypolicies.com/live/edbe4d26-df10-4c51-95b9-d0399c83ad2e',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
