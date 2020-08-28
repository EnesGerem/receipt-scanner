import 'package:flutter/material.dart';

const kDefaultFontFamily = "Spartan-Medium";
const kDefaultFontBold = "Spartan-ExtraBold";
const kDefaultFontMid = "Spartan-Bold";

const kPalette1 = Color(0xFF000000);
const kPalette2 = Color(0xFF1E1E1E);
const kPalette3 = Color(0xFF3C3C3C);
const kPalette4 = Color(0xFF787878);
const kPalette5 = Color(0xFFE0E0E0);

const kAppBlue = Color(0xFF007FFF);

const navigationItemTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  letterSpacing: 2.0,
  fontFamily: "Raleway-Regular",
);

Container buildAppBar(Size size) {
  return Container(
    padding: EdgeInsets.symmetric(
        vertical: size.height * 0.06, horizontal: size.width * 0.04),
    child: Text(
      "VOUCHER SCANNER",
      style: TextStyle(
        fontFamily: "Righteous-Regular",
        color: kPalette2,
        fontSize: 30,
      ),
    ),
  );
}

Padding buildAppBarDivider(Size size) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.135),
    child: Divider(
      color: kPalette2,
      thickness: 3,
    ),
  );
}

Stack appBarContainer(BuildContext context) => Stack(
      children: <Widget>[
        Container(
          height: 150.0,
          decoration: new BoxDecoration(
            color: Colors.grey[850],
            boxShadow: [new BoxShadow(blurRadius: 30.0)],
            borderRadius: new BorderRadius.vertical(
                bottom: new Radius.elliptical(
                    MediaQuery.of(context).size.width, 50.0)),
          ),
        ),
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 60),
              Text(
                "Voucher Scanner",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Colors.white,
                  fontFamily: "Spartan-Black",
                ),
              ),
            ],
          ),
        ),
      ],
    );
