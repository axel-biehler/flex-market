import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Preview page for the picture taken
class PicturePreviewPage extends StatelessWidget {
  /// constructor
  const PicturePreviewPage({required this.picture, super.key});

  /// picture
  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
            const SizedBox(height: 24),
            Text(picture.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Retake'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  // TODO(axel): implement the returned image to use for profile or add products.
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Use Picture'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
