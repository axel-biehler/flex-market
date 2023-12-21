import 'dart:async';

import 'package:flex_market/components/picture_preview.dart';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Image picker widget
class ImagePickerWidget extends StatefulWidget {
  /// constructor
  const ImagePickerWidget({
    required this.navigatorKey,
    required this.maxPictures,
    super.key,
  });

  /// Global key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Maximum number of pictures that can be taken
  final int maxPictures;

  @override

  /// state
  ImagePickerWidgetState createState() => ImagePickerWidgetState();
}

/// Class state
class ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image
    final List<XFile> images = await picker.pickMultiImage();
    unawaited(addImage(images));
  }

  /// Add choosen image to the list of images
  Future<void> addImage(List<XFile>? images) async {
    if (images != null && images.isNotEmpty) {
      context.read<ImageManagementProvider>().setImageUrl(images);
      await Navigator.of(context).push(
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => PicturePreviewPage(
            navigatorKey: widget.navigatorKey,
            maxPictures: widget.maxPictures,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _pickImage,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16), // Add some padding
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.image, color: Colors.black), // Add an icon
        ],
      ),
    );
  }
}
