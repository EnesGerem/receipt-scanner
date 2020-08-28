import "package:flutter/material.dart";
import 'package:receipt_scanner/services/auth.dart';

import 'package:receipt_scanner/shared/constants.dart';
import 'package:receipt_scanner/shared/loading.dart';

import 'constants.dart';

class Register extends StatefulWidget {
  final Function toogleView;

  Register({this.toogleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String rePassword = "";
  String fullName = "";

  String error = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  buildBackground(size),
                  Column(
                    children: <Widget>[
                      SizedBox(height: size.height * 0.08),
                      Image.asset("assets/icon/receipt_logo.png",
                          scale: size.width * 0.013),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: Text(
                          "RECEIPT SCANNER",
                          style: TextStyle(
                            fontFamily: "Righteous-Regular",
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.04,
                            color: kPalette2,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.01,
                            horizontal: size.width * 0.1),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //buildEmailForm(email, setState),
                              RoundedInputField(
                                labelText: "FULL NAME",
                                onChanged: (value) => fullName = value,
                              ),
                              RoundedInputField(
                                labelText: "EMAIL",
                                onChanged: (value) => email = value,
                              ),
                              // buildEmailForm(email, setState),
                              RoundedPasswordField(
                                labelText: "PASSWORD",
                                onChanged: (value) => password = value,
                              ),
                              RoundedPasswordField(
                                labelText: "CONFIRM PASSWORD",
                                onChanged: (value) => rePassword = value,
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              ),
                              buildErrorMessage(size, error),
                              BuildButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });

                                    if (password == rePassword) {
                                      dynamic result = await _auth
                                          .registerWithEmailAndPassword(
                                              email, password, fullName);

                                      if (result == null) {
                                        setState(() {
                                          error = "please supply a valid email";
                                          loading = false;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        error =
                                            "Please confirm your password correctly";
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                text: "Sign Up",
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              BuildRichText(
                                message: 'Already have an account?  ',
                                link: 'Sign In',
                                onTap: widget.toogleView,
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              BuildRichText(
                                  message:
                                      'By clicking Sign Up, you agree to our ',
                                  link: 'Terms of Service',
                                  onTap: () {
                                    print('Terms of Service"');
                                  },
                                  fontSize: size.width * 0.025),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
