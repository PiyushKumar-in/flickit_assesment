import 'package:flickit_assesment/screens/Image_Picker_Screen/image_picker.dart';
import 'package:flickit_assesment/screens/Live_camera/live_cam.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Select Mode",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => CameraScreen()),
                          );
                        },
                        child: Text("Live Camera Feed"),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ImagePickerScreen(),
                            ),
                          );
                        },
                        child: Text("Image/Camera Input"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Made with ❤️, by Piyush Kumar\nin India🥰",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
