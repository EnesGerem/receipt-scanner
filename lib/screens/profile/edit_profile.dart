import 'package:flutter/material.dart';
import 'package:receipt_scanner/models/user.dart';
import 'package:receipt_scanner/screens/authenticate/constants.dart';
import 'package:receipt_scanner/database/firebase_database.dart';
import 'package:receipt_scanner/shared/constants.dart';

class EditProfileForm extends StatefulWidget {
  final currentUser;

  const EditProfileForm({Key key, this.currentUser}) : super(key: key);
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentName;
  String _currentEmailAddress;
  String _currentCompanyName;
  String _currentTaxNumber;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserData currentUser = widget.currentUser;

    TextStyle appBarStyle = TextStyle(
      fontFamily: "Spartan-ExtraBold",
      fontSize: size.width * 0.06,
      color: kPalette2,
      letterSpacing: 0.5,
    );

    TextStyle fieldTitleStyle = TextStyle(
      fontFamily: "Spartan-ExtraBold",
      fontSize: size.width * 0.025,
      color: kPalette2,
      letterSpacing: 1,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        title: Text("Edit Profile", style: appBarStyle),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: kPalette2),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.05),
              child: Column(
                children: <Widget>[
                  SizedBox(height: size.height * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name", style: fieldTitleStyle),
                      // buildTextField(
                      //     currentUser.name, _currentName, setState),
                      TextFormField(
                        initialValue: currentUser.name,
                        validator: (val) => val.isEmpty ? 'Enter a name' : null,
                        onChanged: (val) {
                          setState(() {
                            _currentName = val;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Email", style: fieldTitleStyle),
                      // buildTextField(currentUser.email,
                      //     _currentEmailAddress, setState),
                      TextFormField(
                        initialValue: currentUser.email,
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            _currentEmailAddress = val;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Company", style: fieldTitleStyle),
                      // buildTextField(currentUser.companyName,
                      //     _currentCompanyName, setState),
                      TextFormField(
                        initialValue: currentUser.companyName,
                        onChanged: (val) =>
                            setState(() => _currentCompanyName = val),
                      )
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Tax Number", style: fieldTitleStyle),
                      // buildTextField(currentUser.taxNumber,
                      //     _currentTaxNumber, setState),
                      TextFormField(
                        initialValue: currentUser.taxNumber,
                        onChanged: (val) =>
                            setState(() => _currentTaxNumber = val),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  BuildButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: currentUser.uid)
                            .updateUserData(
                                _currentName ?? currentUser.name,
                                currentUser.isAdmin,
                                _currentEmailAddress ?? currentUser.email,
                                _currentTaxNumber ?? currentUser.taxNumber,
                                _currentCompanyName ?? currentUser.companyName);
                        Navigator.pop(context);
                      } else {}
                    },
                    text: "Save Profile",
                  ),
                  BuildButton(
                    onPressed: () => Navigator.pop(context),
                    text: "Cancel",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
