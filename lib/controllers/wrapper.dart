import 'package:camera/camera.dart';
import "package:flutter/material.dart";
import 'package:receipt_scanner/models/user.dart';
import 'package:receipt_scanner/screens/authenticate/authenticate.dart';

import 'package:provider/provider.dart';
import 'package:receipt_scanner/controllers/navigation/bar_controller.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = false;

    //print(user);

    if (user)
      return Authenticate();
    else
      return NavigationBarController();

    // return Temp();
  }
}
