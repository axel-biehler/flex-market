import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Manages the application state for the images
class ImageManagementProvider with ChangeNotifier {
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

  /// Upload and image to a presignedUrl
  Future<void> uploadXFileToS3(XFile xFile, String presignedUrl) async {
    try {
      final http.Response response = await http.put(
        Uri.parse(presignedUrl),
        body: await xFile.readAsBytes(),
      );
      notifyListeners();

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('File uploaded successfully.');
        }
      } else {
        if (kDebugMode) {
          print('Failed to upload file. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file: $e');
      }
    }
  }

  /// Remove an image from the array [_imageFiles]
  void removeImage(XFile file) {
    _imageFiles.remove(file);
    notifyListeners();
  }

  /// Clear the images loaded in [_imageFiles]
  void clearImages() {
    _imageFiles.clear();
    notifyListeners();
  }
}
