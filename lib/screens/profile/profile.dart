import 'package:flutter/material.dart';
import 'package:receipt_scanner/screens/profile/edit_profile.dart';
import 'package:receipt_scanner/services/auth.dart';
import 'package:receipt_scanner/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:receipt_scanner/models/user.dart';

import '../authenticate/constants.dart';

class Profile extends StatefulWidget {
  final AuthService auth;

  const Profile({Key key, this.auth}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserData currentUser = Provider.of<UserData>(context);
    //getUser(context).then((user) => currentUser = user);

    TextStyle infoTextStyle = TextStyle(
      fontFamily: kDefaultFontFamily,
      fontSize: size.width * 0.0375,
      color: kPalette2,
    );

    TextStyle profileTextStyle = TextStyle(
      fontFamily: "Spartan-ExtraBold",
      fontSize: size.width * 0.0375,
      color: kAppBlue,
    );

    void _showEditProfilePanel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return EditProfileForm(
              currentUser: currentUser,
            );
          });
    }

    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
            child: CircleAvatar(
              backgroundColor: kAppBlue,
              radius: size.height * 0.0875,
              child: Image.asset(
                "assets/icon/profile.png",
                scale: 7,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Name:", style: profileTextStyle),
                    SizedBox(height: size.height * 0.02),
                    Text("Email:", style: profileTextStyle),
                    SizedBox(height: size.height * 0.02),
                    Text("Company:", style: profileTextStyle),
                    SizedBox(height: size.height * 0.02),
                    Text("Tax Number:", style: profileTextStyle),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(currentUser.name ?? "", style: infoTextStyle),
                    SizedBox(height: size.height * 0.02),
                    Text(currentUser.email ?? "", style: infoTextStyle),
                    SizedBox(height: size.height * 0.02),
                    Text(
                        currentUser.companyName == null ||
                                currentUser.companyName.isEmpty
                            ? "[Company Name]"
                            : currentUser.companyName,
                        style: infoTextStyle),
                    SizedBox(height: size.height * 0.02),
                    Text(
                        currentUser.taxNumber == null ||
                                currentUser.taxNumber.isEmpty
                            ? "[Tax Number]"
                            : currentUser.taxNumber,
                        style: infoTextStyle),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Stack(
                children: [
                  BuildButton(
                    onPressed: () {
                      _showEditProfilePanel();
                    },
                    text: "Edit Profile",
                  ),
                  Padding(
                    //margin: EdgeInsets.symmetric(vertical: size.height * 0.0125)
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.06, size.height * 0.037, 0, 0),
                    child: Icon(
                      Icons.edit,
                      color: kPalette5,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  BuildButton(
                    onPressed: () async {
                      await widget.auth.signOut();
                    },
                    text: "Sign Out",
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.06, size.height * 0.037, 0, 0),
                    child: Icon(
                      Icons.exit_to_app,
                      color: kPalette5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
