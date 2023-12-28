import 'package:flutter/material.dart';

/// A widget that displays an image from an url.
///
/// The widget requires an [url].
class ImageViewerWidget extends StatelessWidget {
  /// Creates a [ImageViewerWidget].
  ///
  /// Requires [url] string to be provided.
  const ImageViewerWidget({
    required this.url,
    super.key,
  });

  /// The url where the image is stored.
  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: 150,
      height: 150,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          ),
        );
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Icon(Icons.error);
      },
    );
  }
}
