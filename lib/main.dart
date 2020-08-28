import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';

import 'package:receipt_scanner/controllers/wrapper.dart';
import 'package:receipt_scanner/screens/screens.dart';
import 'package:receipt_scanner/shared/constants.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Receipt Scanner",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: kDefaultFontFamily,
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(displayColor: kPalette2),
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Wrapper(),
        '/data': (BuildContext context) => Data(),
        '/profile': (BuildContext context) => Profile(),
        '/signIn': (BuildContext context) => SignIn(),
        '/register': (BuildContext context) => Register(),
      },
      home: Wrapper(),
    );
  }
}
