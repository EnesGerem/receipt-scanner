import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_scanner/database/firebase_database.dart';
import 'package:receipt_scanner/models/user.dart';
import 'package:receipt_scanner/screens/screens.dart';
import 'package:receipt_scanner/services/auth.dart';
import 'package:receipt_scanner/shared/constants.dart';
import 'navigation.dart';

class NavigationBarController extends StatefulWidget {
  final CameraDescription camera;

  const NavigationBarController({Key key, this.camera}) : super(key: key);
  @override
  _NavigationBarControllerState createState() =>
      _NavigationBarControllerState();
}

class _NavigationBarControllerState extends State<NavigationBarController> {
  int _currentIndex = 0;
  final NavigationBloc bloc = NavigationBloc();
  final AuthService _auth = AuthService();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    User user = User(
        uid: "WsgHAykbgiahZl7U3mt2wXDoRLF2",
        name: "Enes Gerem",
        email: "eneesgerem@gmail.com");
    Size size = MediaQuery.of(context).size;
    return StreamProvider.value(
      value: DatabaseService(uid: user.uid).userData,
      child: Scaffold(
        appBar: buildAppBar(size),
        body: buildBody(),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  StreamBuilder<Navigation> buildBody() {
    return StreamBuilder<Navigation>(
      stream: bloc.currentNavigationIndex,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _currentIndex = snapshot.data.index;

          switch (snapshot.data) {
            case Navigation.HOMEPAGE:
              return HomePage(camera: widget.camera, bloc: bloc);
            case Navigation.DATA:
              return Data(camera: widget.camera, bloc: bloc);
            case Navigation.PROFILE:
              return Profile(auth: _auth);
          }

          return CircularProgressIndicator();
        } else
          return CircularProgressIndicator();
      },
    );
  }

  AppBar buildAppBar(Size size) {
    return AppBar(
      toolbarHeight: size.height * 0.1,
      backgroundColor: kPalette2,
      brightness: Brightness.dark,
      title: Text(
        "RECEIPT SCANNER",
        style: TextStyle(
          fontFamily: "Righteous-Regular",
          color: Colors.white,
          fontSize: size.width * .0625,
        ),
      ),
      elevation: 0,
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: kAppBlue,
      unselectedItemColor: kPalette5,
      backgroundColor: kPalette2,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          // icon: Icon(
          //   Icons.home,
          // ),
          icon: Image.asset("assets/icon/home.png", scale: 20),
          title: Text('Home', style: navigationItemTextStyle),
          activeIcon: Image.asset("assets/icon/homeon.png", scale: 20),
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icon/data.png", scale: 20),
          title: Text(
            'Data',
            style: navigationItemTextStyle,
          ),
          activeIcon: Image.asset("assets/icon/dataon.png", scale: 20),
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icon/profile.png", scale: 20),
          title: Text(
            'Profile',
            style: navigationItemTextStyle,
          ),
          activeIcon: Image.asset("assets/icon/profileon.png", scale: 20),
        ),
      ],
      elevation: 0,
      currentIndex: _currentIndex,
      onTap: (index) {
        bloc.changeNavigationIndex(Navigation.values[index]);
        bloc.currentNavigationIndex
            .listen((navItem) => setState(() => _currentIndex = navItem.index));
      },
    );
  }
}
