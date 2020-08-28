import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:receipt_scanner/controllers/navigation/navigation.dart';
import 'package:receipt_scanner/services/scan.dart';

import 'package:receipt_scanner/shared/constants.dart';
import 'package:receipt_scanner/screens/data/data.dart';
import 'package:receipt_scanner/controllers/navigation/bar_controller.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;
  final NavigationBloc bloc;

  const HomePage({Key key, this.camera, this.bloc}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return buildHomeBody(size);
  }

  Column buildHomeBody(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/icon/receipt_logo.png", scale: 3),
        SizedBox(height: size.height * .0625),
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
          child: Text('Pick to scan your voucher',
              style: TextStyle(
                color: kPalette2,
                fontFamily: 'Spartan-Medium',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Card(
                  color: kPalette2,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        //TODO: Push to scan.dart
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scan(
                                    camera: widget.camera, bloc: widget.bloc)));
                      },
                      highlightColor: kPalette2,
                      iconSize: 40,
                      icon: Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.00625,
                ),
                Text(
                  "New Photo",
                  style: TextStyle(
                    fontFamily: "Raleway-Regular",
                    color: kPalette2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Card(
                  color: kPalette2,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        //TODO:Push to pick_image.dart
                      },
                      highlightColor: Colors.grey,
                      iconSize: 36,
                      icon: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.00625,
                ),
                Text(
                  "Select from gallery",
                  style: TextStyle(
                    fontFamily: "Raleway-Regular",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
