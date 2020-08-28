import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:receipt_scanner/controllers/navigation/navigation.dart';
import 'package:receipt_scanner/services/read_text.dart';

import 'package:receipt_scanner/shared/constants.dart';
import 'package:receipt_scanner/shared/loading.dart';

class Scan extends StatefulWidget {
  final CameraDescription camera;
  final NavigationBloc bloc;

  const Scan({Key key, this.camera, this.bloc}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool loading = false;

  void initState() {
    print("camera class");
    // To display the current output from the Camera,
    // creating a CameraController.
    _controller = CameraController(
      // Getring a specific camera from the list of available cameras.
      widget.camera,
      // Defining the resolution to use.
      ResolutionPreset.veryHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    // Disposing of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            // Wait until the controller is initialized before displaying the
            // camera preview. Use a FutureBuilder to display a loading spinner
            // until the controller has finished initializing.
            body: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.camera_alt, color: kPalette2),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              // Provide an onPressed callback.
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Construct the path where the image should be saved using the
                  // pattern package.
                  final path = join(
                    // Store the picture in the temp directory.
                    // Find the temp directory using the `path_provider` plugin.
                    (await getTemporaryDirectory()).path,
                    'newImage.jpg',
                  );

                  // Attempt to take a picture and log where it's been saved.
                  File thefile = File(path);

                  if (await thefile.exists()) await thefile.delete();

                  await _controller.takePicture(path);

                  /////////////////////////////////////add here

                  //TODO: Push to read_text.dart

                  bool done = await operations(File(path));

                  if (done)
                    print("successful");
                  else
                    print("unsuccessful");

                  setState(() {
                    widget.bloc.changeNavigationIndex(Navigation.DATA);
                  });
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ReadText(imageFile: File(path))));

                  /////////////////////////////////////////////

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => MLPage(
                  //             File(path), widget.storage, true, widget.camera)));

                  // If the picture was taken, display it on a new screen.

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DisplayPictureScreen(
                  //       imagePath: path,
                  //       storage: widget.storage,
                  //       camera: widget.camera,
                  //     ),
                  //   ),
                  // );
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

/*
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final MyStorage storage;

  final CameraDescription camera;

  DisplayPictureScreen({Key key, this.imagePath, this.storage, this.camera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    File image = File(imagePath);
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(child: Image.file(image, fit: BoxFit.contain)),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.done,
          size: 30,
        ),
        onPressed: () {
          if (image != null) {
            imageCache.clear();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MLPage(image, storage, true, camera)));
          }
        },
      ),
    );
  }
}

*/
