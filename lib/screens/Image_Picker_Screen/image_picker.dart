import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flickit_assesment/screens/Image_Result_Screen/image_result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as imgPick;

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image/Camera Input")),
      body: Center(child: ImagePicker()),
    );
  }
}

class ImagePicker extends StatefulWidget {
  const ImagePicker({super.key});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  Widget? img;
  bool hasImage = false;
  XFile? orignalImage;
  final imgPick.ImagePicker picker = imgPick.ImagePicker();

  Future<imgPick.ImageSource?> selectOption() async {
    if (context.mounted) {
      imgPick.ImageSource? source = await showModalBottomSheet(
        context: context,
        builder:
            (ctx) => Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Select Image Source",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop(imgPick.ImageSource.camera);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.camera_alt, size: 30),
                                Text("Camera"),
                              ],
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop(imgPick.ImageSource.gallery);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image, size: 30),
                                Text("Gallery"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      );
      return source;
    }
    return null;
  }

  void pickImage(double height, double width) async {
    imgPick.ImageSource? source = await selectOption();
    if (source == null) return;

    XFile? imgPicked = await picker.pickImage(source: source);
    if (imgPicked == null) return;
    orignalImage = imgPicked;
    Uint8List data = await imgPicked.readAsBytes();
    setState(() {
      img = Image.memory(
        data,
        fit: BoxFit.contain,
        height: height - 180,
        width: width - 50,
      );
      hasImage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, conts) {
        img ??= Container(
          height: conts.maxHeight - 180,
          width: conts.maxWidth - 50,
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
          child: Center(child: Text("Nothing Picked")),
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                pickImage(conts.maxHeight, conts.maxWidth);
              },
              child: img!,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  pickImage(conts.maxHeight, conts.maxWidth);
                },
                child: Text(
                  (hasImage) ? "Pick Different Image" : "Pick Image",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            if (hasImage) SizedBox(height: 5),
            if (hasImage)
              SizedBox(
                width: 200,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (ctx) => ImageResultScreen(file: orignalImage!),
                      ),
                    );
                  },
                  child: Text(
                    "Select This Image",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            if (hasImage) SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
