class User {
  final String uid;
  final String name;
  final String email;

  User({this.uid, this.name, this.email});

  @override
  String toString() {
    return "User signed in with name: $name, email: $email, uid: $uid";
  }
}

class UserData {
  final String uid;
  final String name;
  final String email;
  final String companyName;
  final String taxNumber;

  final bool isAdmin;

  UserData(
      {this.uid,
      this.name,
      this.email,
      this.companyName,
      this.taxNumber,
      this.isAdmin});
}
