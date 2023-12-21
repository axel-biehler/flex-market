import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flex_market/components/image_picker.dart';
import 'package:flex_market/components/picture_preview.dart';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// CameraPage class used to display the camera preview
class CameraPage extends StatefulWidget {
  /// constructor
  const CameraPage({
    required this.navigatorKey,
    this.maxPictures = 1,
    super.key,
  });

  /// Global key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Maximum number of pictures that can be taken
  final int maxPictures;

  /// cameras
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  bool loading = true;
  late List<CameraDescription>? cameras;

  @override
  void dispose() {
    unawaited(_cameraController.dispose());
    super.dispose();
  }

  Future<void> getCameras() async {
    cameras = await availableCameras();
    await initCamera(cameras!.first);
    loading = false;
  }

  @override
  void initState() {
    super.initState();
    unawaited(getCameras());
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized ||
        _cameraController.value.isTakingPicture) {
      return;
    }

    try {
      await _cameraController.setFlashMode(FlashMode.off);
      final XFile picture = await _cameraController.takePicture();

      // Check if the widget is still in the tree after async gap
      if (!mounted) return;
      Provider.of<ImageManagementProvider>(context, listen: false)
          .setImageUrl(<XFile>[picture]);
      await widget.navigatorKey.currentState?.push(
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => PicturePreviewPage(
            navigatorKey: widget.navigatorKey,
            maxPictures: widget.maxPictures,
          ),
        ),
      );
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
    }
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint('camera error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photo',
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
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (loading)
              const ColoredBox(
                color: Colors.black,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_cameraController.value.isInitialized)
              CameraPreview(_cameraController)
            else
              const ColoredBox(
                color: Colors.black,
                child: Center(child: CircularProgressIndicator()),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ImagePickerWidget(
                        navigatorKey: widget.navigatorKey,
                        maxPictures: widget.maxPictures,
                      ),
                    ),
                    Expanded(
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.grey, // Set the background color
                          shape: BoxShape.circle, // Make the container circular
                        ),
                        child: IconButton(
                          onPressed: takePicture,
                          iconSize: 50,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.circle, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        icon: Icon(
                          _isRearCameraSelected
                              ? CupertinoIcons.switch_camera
                              : CupertinoIcons.switch_camera_solid,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(
                            () =>
                                _isRearCameraSelected = !_isRearCameraSelected,
                          );
                          unawaited(
                            initCamera(
                              cameras![_isRearCameraSelected ? 0 : 1],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
