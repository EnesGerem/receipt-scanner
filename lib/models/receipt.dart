import 'dart:convert';

Receipt receiptFromJson(String str) {
  final jsonData = json.decode(str);
  return Receipt.fromMap(jsonData);
}

String receiptToJson(Receipt data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Receipt {
  int id;
  String firstName;
  String lastName;

  Receipt({
    this.id,
    this.firstName,
    this.lastName,
  });

  factory Receipt.fromMap(Map<String, dynamic> json) => new Receipt(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
      };

  @override
  String toString() {
    return "id: $id\tname: $firstName $lastName";
  }
}
