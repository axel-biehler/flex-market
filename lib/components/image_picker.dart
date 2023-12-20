import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Image picker widget
class ImagePickerWidget extends StatefulWidget {
  /// constructor
  const ImagePickerWidget({super.key});

  @override

  /// state
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_image == null)
          const Text('No image selected.')
        else
          Container(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: FileImage(File(_image!.path)),
            ),
          ),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Pick Image'),
        ),
      ],
    );
  }
}
