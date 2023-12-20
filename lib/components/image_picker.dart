import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Image picker widget
class ImagePickerWidget extends StatefulWidget {
  /// constructor
  const ImagePickerWidget({super.key});

  @override

  /// state
  ImagePickerWidgetState createState() => ImagePickerWidgetState();
}

/// Class state
class ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _pickImage,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
      ),
      child: _image == null
          ? const Text('Pick Image')
          : CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(File(_image!.path)),
            ),
    );
  }
}
