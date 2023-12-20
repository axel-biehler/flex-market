import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flex_market/components/image_picker.dart';
import 'package:flex_market/components/picture_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// CameraPage class used to display the camera preview
class CameraPage extends StatefulWidget {
  /// constructor
  const CameraPage({required this.navigatorKey, super.key});

  /// Global key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

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

      await Navigator.of(context).push(
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => PicturePreviewPage(
            picture: picture,
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
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xFF3D3D3B),
              ),
              child: IconButton(
                icon: Transform.rotate(
                  angle: pi,
                  child: SvgPicture.asset('assets/arrow.svg', height: 20),
                ),
                onPressed: () => widget.navigatorKey.currentState?.pop(),
                highlightColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
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
                    const Expanded(
                      child: ImagePickerWidget(),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: takePicture,
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.circle, color: Colors.white),
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
