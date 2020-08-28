import 'package:camera/camera.dart';
import "package:flutter/material.dart";
import 'package:receipt_scanner/models/user.dart';
import 'package:receipt_scanner/screens/authenticate/authenticate.dart';

import 'package:provider/provider.dart';
import 'package:receipt_scanner/controllers/navigation/bar_controller.dart';

class Wrapper extends StatelessWidget {
  final CameraDescription camera;

  Wrapper({Key key, @required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //print(user);

    if (user == null)
      return Authenticate();
    else
      return NavigationBarController(camera: camera);
  }
}
