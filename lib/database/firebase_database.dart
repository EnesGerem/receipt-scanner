import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipt_scanner/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String name, bool isAdmin, String email,
      String taxNumber, String companyName) async {
    return await userCollection.document(uid).setData({
      "uid": uid,
      "name": name,
      "isAdmin": isAdmin ?? false,
      "email": email,
      "taxNumber": taxNumber,
      "companyName": companyName,
    });
  }

  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserData(
        uid: doc.data["uid"],
        name: doc.data["name"] ?? "",
        isAdmin: doc.data["isAdmin"] ?? false,
        email: doc.data["email"] ?? "",
        taxNumber: doc.data["taxNumber"] ?? "",
        companyName: doc.data["companyName"] ?? "",
      );
    }).toList();
  }

  //user from snapshot
  UserData _userFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data["name"] ?? "",
      email: snapshot.data["email"] ?? "",
      isAdmin: snapshot.data["isAdmin"] ?? "",
      taxNumber: snapshot.data["taxNumber"] ?? "",
      companyName: snapshot.data["companyName"] ?? "",
    );
  }

  //get users stream
  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userFromSnapshot);
  }
}
