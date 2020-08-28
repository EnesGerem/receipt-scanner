import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

import 'package:receipt_scanner/controllers/wrapper.dart';
import 'package:receipt_scanner/models/user.dart';
import 'package:receipt_scanner/screens/screens.dart';
import 'package:receipt_scanner/services/auth.dart';
import 'package:receipt_scanner/shared/constants.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key key, this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        title: "Receipt Scanner",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: kDefaultFontFamily,
          scaffoldBackgroundColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(displayColor: kPalette2),
        ),
        routes: <String, WidgetBuilder>{
          '/data': (BuildContext context) => Data(),
          '/profile': (BuildContext context) => Profile(),
          '/signIn': (BuildContext context) => SignIn(),
          '/register': (BuildContext context) => Register(),
        },
        home: Wrapper(camera: this.camera),
      ),
    );
  }
}
