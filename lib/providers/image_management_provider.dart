import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// Manages the application state for the images
class ImageManagementProvider with ChangeNotifier {
  // Add your provider properties and methods here

  // Example property
  final List<XFile> _imageFiles = <XFile>[];

  /// Getter for the list of images
  List<XFile> get imageFiles => _imageFiles;

  /// Adds an image to the list of images
  void setImageUrl(List<XFile> images) {
    _imageFiles.addAll(images);
    notifyListeners();
  }

  /// Removes an image from the list of images
  void removeImageUrl(XFile image) {
    _imageFiles.remove(image);
    notifyListeners();
  }

  /// Clears the list of images
  void clearImageUrls() {
    _imageFiles.clear();
    notifyListeners();
  }
}
