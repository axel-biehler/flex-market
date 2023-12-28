import 'dart:io';
import 'package:flex_market/components/camera_picker.dart';
import 'package:flex_market/components/image_picker.dart';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Build the image item
Widget buildImageItem(BuildContext context, int index, double imageSize) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        SizedBox(
          width: imageSize,
          height: imageSize,
          child: Image.file(
            File(
              context.watch<ImageManagementProvider>().imageFiles[index].path,
            ),
            fit: BoxFit.cover,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            context.read<ImageManagementProvider>().removeImageUrl(
                  context.read<ImageManagementProvider>().imageFiles[index],
                );
          },
        ),
      ],
    ),
  );
}

/// CameraPage class used to display the camera preview
class PicturePreviewPage extends StatelessWidget {
  /// constructor
  const PicturePreviewPage({
    required this.navigatorKey,
    required this.maxPictures,
    required this.callback,
    super.key,
  });

  /// Global key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Maximum number of pictures that can be taken
  final int maxPictures;

  /// Callback function to be executed when the user presses the check button
  final Future<void> Function(List<XFile> pics) callback;

  @override
  Widget build(BuildContext context) {
    const double imageSize = 150;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Picture Preview',
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC2C2C2)),
          onPressed: () => <void>{
            Navigator.of(context).pop(),
            context.read<ImageManagementProvider>().clearImageUrls(),
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                height: imageSize,
                child: context.watch<ImageManagementProvider>().imageFiles.isEmpty
                    ? Flex(
                        mainAxisAlignment: MainAxisAlignment.center,
                        direction: Axis.vertical,
                        children: <Widget>[
                          const Expanded(
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No images selected',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: context.watch<ImageManagementProvider>().imageFiles.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == context.watch<ImageManagementProvider>().imageFiles.length) {
                            return CameraPickerWidget(
                              navigatorKey: navigatorKey,
                              maxPictures: maxPictures,
                            );
                          } else {
                            return buildImageItem(context, index, imageSize);
                          }
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ImagePickerWidget(
                navigatorKey: navigatorKey,
                maxPictures: maxPictures,
              ),
              const SizedBox(width: 24),
              CameraPickerWidget(
                navigatorKey: navigatorKey,
                maxPictures: maxPictures,
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                onPressed: context.watch<ImageManagementProvider>().imageFiles.isNotEmpty
                    ? () async {
                        await callback(context.read<ImageManagementProvider>().imageFiles);
                        navigatorKey.currentState?.pop();
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey[800]!;
                      }
                      return const Color(0xFF247100);
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return 0.0;
                      }
                      return 4.0;
                    },
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
