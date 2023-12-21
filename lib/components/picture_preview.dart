import 'dart:io';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// CameraPage class used to display the camera preview
class PicturePreviewPage extends StatelessWidget {
  /// constructor
  const PicturePreviewPage({
    required this.navigatorKey,
    required this.maxPictures,
    super.key,
  });

  /// Global key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Maximum number of pictures that can be taken
  final int maxPictures;

  @override
  Widget build(BuildContext context) {
    // Define the fixed size for the images (square)
    const double imageSize = 150; // Size for both width and height

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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: context
                      .watch<ImageManagementProvider>()
                      .imageFiles
                      .length,
                  itemBuilder: (BuildContext context, int index) {
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
                                context
                                    .watch<ImageManagementProvider>()
                                    .imageFiles[index]
                                    .path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<ImageManagementProvider>()
                                  .removeImageUrl(
                                    context
                                        .read<ImageManagementProvider>()
                                        .imageFiles[index],
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed:
                    context.watch<ImageManagementProvider>().imageFiles.length <
                            maxPictures
                        ? () => navigatorKey.currentState?.pop()
                        : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      const Color.fromARGB(255, 48, 48, 48),
                  disabledForegroundColor: const Color.fromARGB(109, 2, 2, 2),
                ),
                child: const Text(
                  'Retake a picture',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                onPressed: () => navigatorKey.currentState?.pop(),
                child: const Text(
                  'Use Pictures',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
