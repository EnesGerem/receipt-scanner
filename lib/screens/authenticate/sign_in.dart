import 'package:receipt_scanner/services/auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:receipt_scanner/shared/loading.dart';
import 'package:receipt_scanner/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  SignIn({this.toogleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field state
  String email = "";
  String password = "";
  String error = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //Height: 592 Width: 360
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
                              RoundedInputField(
                                labelText: "EMAIL",
                                onChanged: (value) => email = value,
                              ),
                              // buildEmailForm(email, setState),
                              RoundedPasswordField(
                                labelText: "PASSWORD",
                                onChanged: (value) => password = value,
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              ),
                              buildErrorMessage(size, error),
                              //buildPasswordForm(password, setState),
                              BuildButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);

                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);

                                    if (result == null)
                                      setState(() {
                                        error = "Incorrect email or password";
                                        loading = false;
                                      });
                                  }
                                },
                                text: "Sign In",
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.005),
                                child: BuildRichText(
                                  message: '',
                                  link: 'Forgot Password?',
                                  onTap: widget.toogleView,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              BuildRichText(
                                message: 'Don\'t have an account?  ',
                                link: 'Sign Up',
                                onTap: widget.toogleView,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.035,
                      ),
                      buildOrDivider(size),
                      SizedBox(
                        height: size.height * 0.035,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialIcon(
                            iconSrc: "assets/icon/facebook.png",
                            press: () async {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInWithGoogle();

                              if (result == null)
                                setState(() {
                                  error = "Incorrect email or password";
                                  loading = false;
                                });
                            },
                          ),
                          SocialIcon(
                            iconSrc: "assets/icon/google.png",
                            press: () async {
                              setState(() => loading = true);
                              await _auth.signInWithGoogle();
                            },
                          ),
                          SocialIcon(
                            iconSrc: "assets/icon/apple.png",
                            press: () async {
                              setState(() => loading = true);
                              await _auth.signInWithGoogle();
                            },
                          ),
                          SocialIcon(
                            iconSrc: "assets/icon/twitter.png",
                            press: () async {
                              setState(() => loading = true);
                              await _auth.signInWithGoogle();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
