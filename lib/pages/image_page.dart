import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(child: InteractiveViewer(child: Image.asset(imagePath))),
    );
  }
}
