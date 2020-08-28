import 'package:flutter/material.dart';
import 'package:receipt_scanner/screens/screens.dart';
import 'package:receipt_scanner/shared/constants.dart';
import 'navigation.dart';

class NavigationBarController extends StatefulWidget {
  @override
  _NavigationBarControllerState createState() =>
      _NavigationBarControllerState();
}

class _NavigationBarControllerState extends State<NavigationBarController> {
  int _currentIndex = 0;
  final NavigationBloc bloc = new NavigationBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(size),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
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
              return HomePage();
            case Navigation.DATA:
              return Data(bloc: bloc);
            case Navigation.PROFILE:
              return Profile();
          }

          return CircularProgressIndicator();
        } else
          return CircularProgressIndicator();
      },
    );
  }

  AppBar buildAppBar(Size size) {
    return AppBar(
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
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            'Home',
            style: navigationItemTextStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud_done),
          title: Text(
            'Data',
            style: navigationItemTextStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text(
            'Profile',
            style: navigationItemTextStyle,
          ),
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
