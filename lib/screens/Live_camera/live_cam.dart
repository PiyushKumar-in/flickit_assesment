import 'dart:math';

import 'package:camera/camera.dart' as cam;
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<cam.CameraDescription> cameras;
  Widget? camDisplay;
  int index = -1;

  cam.CameraController? _controller;
  void setupCameras() async {
    index++;
    cameras = await cam.availableCameras();
    _controller = cam.CameraController(
      cameras[index % cameras.length],
      cam.ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();

    setState(() {
      camDisplay = LayoutBuilder(
        builder: (ctx, consts) {
          final ar = _controller!.value.aspectRatio;
          final height = min(consts.maxHeight, consts.maxWidth * ar);
          return SizedBox(
            height: height,
            width: height / ar,
            child: _controller!.buildPreview(),
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setupCameras();
    WidgetsBinding.instance.addPostFrameCallback((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Not Implemented Completely. Use Other Mode")),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Camera Feed",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Center(child: (camDisplay ?? CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            camDisplay = null;
            _controller?.dispose();
          });
          setupCameras();
        },
        child: Icon(Icons.change_circle),
      ),
    );
  }
}
