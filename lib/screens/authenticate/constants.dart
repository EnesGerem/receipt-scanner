import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:receipt_scanner/shared/constants.dart';

class BuildButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const BuildButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.0125),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
          color: kPalette2,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: kDefaultFontFamily,
              color: Colors.white,
              fontSize: size.height * 0.01875,
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocialIcon({
    Key key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.height * 0.015),
        padding: EdgeInsets.all(size.height * 0.0125),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: kPalette2,
          ),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          iconSrc,
          scale: size.height * 0.035,
        ),
      ),
    );
  }
}

Text buildErrorMessage(Size size, String error) {
  return Text(
    error,
    style: TextStyle(
      color: Colors.red,
      fontSize: (size.width - size.width * 0.2) * 0.045,
      fontFamily: "Spartan-Medium",
    ),
  );
}

Container buildBackground(Size size) {
  return Container(
    width: double.infinity,
    height: size.height,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: -5,
          right: -5,
          child: Image.asset(
            "assets/background/right.png",
            width: size.width * 0.25,
          ),
        ),
        Positioned(
          bottom: -10,
          left: -10,
          child: Image.asset(
            "assets/background/bttm.png",
            width: size.width * 0.4,
          ),
        ),
      ],
    ),
  );
}

const textInputDecoration = InputDecoration(
  hintStyle: TextStyle(
    fontFamily: "Spartan",
    fontWeight: FontWeight.w600,
    color: Color(0xFF424242),
  ),
  fillColor: Colors.transparent,
);

TextFormField buildTextField(String holder, String update, setState) {
  return TextFormField(
    initialValue: holder,
    onChanged: (val) {
      update = val;
    },
  );
}

// ignore: must_be_immutable
class BuildRichText extends StatelessWidget {
  final String message;
  final String link;
  final Function onTap;

  double fontSize;

  BuildRichText({Key key, this.message, this.link, this.onTap, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: kDefaultFontFamily,
          fontSize: fontSize == null
              ? (size.width - size.width * 0.2) * 0.045
              : fontSize,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: message,
            style: TextStyle(
              fontFamily: "Spartan",
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
              text: link,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kAppBlue,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap),
        ],
      ),
    );
  }
}

Stack buildOrDivider(Size size) {
  return Stack(
    children: [
      Divider(
        color: Color(0xFFD9D9D9),
        thickness: 2,
        indent: size.width * 0.12,
        endIndent: size.width * 0.12,
      ),
      Center(
        child: Text("    OR    ",
            style: TextStyle(
                backgroundColor: Colors.white,
                fontFamily: "Spartan",
                fontWeight: FontWeight.w600,
                color: kPalette2)),
      ),
    ],
  );
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.005),
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.001),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPalette5,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String labelText;
  final icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.labelText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: kPalette2,
        decoration: InputDecoration(
          icon: icon,
          labelText: labelText,
          labelStyle: TextStyle(
              fontSize: size.height * 0.01625, color: Colors.grey[600]),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String labelText;
  const RoundedPasswordField({Key key, this.onChanged, this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPalette2,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock_outline,
            color: kPalette2,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPalette2,
          ),
          border: InputBorder.none,
          labelText: labelText,
          labelStyle: TextStyle(
              fontSize: size.height * 0.01625, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
