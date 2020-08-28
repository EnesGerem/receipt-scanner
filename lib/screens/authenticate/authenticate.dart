import "package:flutter/material.dart";
import 'package:receipt_scanner/screens/authenticate/register.dart';
import 'package:receipt_scanner/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toogleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn)
      return SignIn();
    else
      return Register();
  }
}
