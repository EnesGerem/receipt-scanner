import 'package:rxdart/rxdart.dart';

enum Navigation { HOMEPAGE, DATA, PROFILE }

class NavigationBloc {
  //BehaviorSubject is from rxdart package
  final BehaviorSubject<Navigation> _navigationController =
      BehaviorSubject.seeded(Navigation.HOMEPAGE);
  // seeded with inital page value. I'am assuming PAGE_ONE value as initial page.

  //exposing stream that notify us when navigation index has changed
  Stream<Navigation> get currentNavigationIndex => _navigationController.stream;
  // method to change your navigation index
  // when we call this method it sends data to stream and his listener
  // will be notified about it.
  void changeNavigationIndex(final Navigation option) =>
      _navigationController.sink.add(option);

  void dispose() => _navigationController?.close();
}
