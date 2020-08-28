import 'package:firebase_auth/firebase_auth.dart';
import 'package:receipt_scanner/models/user.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:receipt_scanner/database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //auth change user stream
  Stream<User> get user => _auth.onAuthStateChanged.map(_userFromFirebaseUser);

  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }

  Future getCurrentUser() async {
    return await _auth.currentUser();
  }

  bool isFirebase = false;
  bool isGoogle = false;

  //creating user object based on FireBaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, name: user.displayName, email: user.email)
        : null;
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    await updateUserName(name, authResult.user);
    return _userFromFirebaseUser(authResult.user);
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    currentUser.updateProfile(userUpdateInfo);
    currentUser.reload();
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      isFirebase = true;

      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      AuthResult result = await _auth.signInWithCredential(credential);
      User user = _userFromFirebaseUser(result.user);

      //creating a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData(user.name, false, user.email, null, null);

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      User user = await createUserWithEmailAndPassword(email, password, name);

      //creating a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData(user.name, false, user.email, null, null);

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
