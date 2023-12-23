import 'dart:async';

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

    if (widget.maxPictures == 1) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      unawaited(addImage(<XFile>[image!]));
    } else {
      final List<XFile> images = await picker.pickMultiImage();
      unawaited(addImage(images));
    }
  }

  /// Add choosen image to the list of images
  Future<void> addImage(List<XFile>? images) async {
    if (images != null && images.isNotEmpty) {
      context.read<ImageManagementProvider>().setImageUrl(images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: context.watch<ImageManagementProvider>().imageFiles.length <
              widget.maxPictures
          ? _pickImage
          : null,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor:
            context.watch<ImageManagementProvider>().imageFiles.length <
                    widget.maxPictures
                ? Colors.orange
                : Colors.grey[800],
        padding: const EdgeInsets.all(16),
        disabledForegroundColor: Colors.grey.withOpacity(0.38),
        disabledBackgroundColor: Colors.grey.withOpacity(0.12),
      ).copyWith(
        elevation: ButtonStyleButton.allOrNull(
          0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.image,
            color: context.watch<ImageManagementProvider>().imageFiles.length <
                    widget.maxPictures
                ? Colors.white
                : Colors.grey[800],
          ), // White icon to contrast with darker disabled color
        ],
      ),
    );
  }
}
