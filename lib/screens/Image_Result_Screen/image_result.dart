import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

Random random = Random();

class ImageResultScreen extends StatefulWidget {
  const ImageResultScreen({super.key, required this.file});
  final XFile file;

  @override
  State<ImageResultScreen> createState() => _ImageResultScreenState();
}

class _ImageResultScreenState extends State<ImageResultScreen> {
  final _channel = MethodChannel("ML_KIT_CHANNEL");
  Widget current = CircularProgressIndicator();

  Future<Uint8List> drawBoundingBoxesOnImage(List<dynamic> objects) async {
    final imageBytes = await widget.file.readAsBytes();
    img.Image original = img.decodeImage(imageBytes)!;

    for (var obj in objects) {
      if (obj is Map) {
        final box = obj['boundingBox'];
        if (box != null) {
          final left = (box['left'] ?? 0).toInt();
          final top = (box['top'] ?? 0).toInt();
          final right = (box['right'] ?? 0).toInt();
          final bottom = (box['bottom'] ?? 0).toInt();

          final r = random.nextInt(256);
          final g = random.nextInt(256);
          final b = random.nextInt(256);

          original = img.drawRect(
            original,
            x1: left,
            y1: top,
            x2: right,
            y2: bottom,
            color: img.ColorRgb8(r, g, b),
            thickness: (original.width / 120).toInt() + 1,
          );

          print("Left: $left, Right: $right, Top: $top, Bottom: $bottom");

          if (obj['labels'] != null &&
              obj['labels'] is List &&
              obj['labels'].isNotEmpty) {
            final label = obj['labels'][0]['text'].toString();
            print(label);
            original = img.drawString(
              original,
              label,
              font: img.arial48,
              x: left,
              y: (top - 49).clamp(0, original.height),
              color: img.ColorRgb8(r, g, b),
            );
          }
        }
      }
    }
    return Uint8List.fromList(img.encodeJpg(original));
  }

  void getPredictions() async {
    var output = await _channel.invokeMethod("MlMethod", {
      "fileName": widget.file.name,
      "filePath": widget.file.path,
    });

    final imgPostProcess = await drawBoundingBoxesOnImage(output);
    setState(() {
      current = Image.memory(imgPostProcess);
    });
  }

  @override
  void initState() {
    super.initState();
    getPredictions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Objects Detected")),
      body: Center(child: current),
    );
  }
}
