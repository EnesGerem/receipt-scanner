import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:receipt_scanner/database/local_database.dart';
import 'package:receipt_scanner/models/receipt.dart';
import 'package:receipt_scanner/shared/loading.dart';

Future<bool> operations(File imageFile) async {
  if (imageFile != null) {
    await img2Text(imageFile);
    return true;
  } else {
    return false;
  }
}

Future img2Text(image) async {
  bool isAdded = false;

  FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
  TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
  VisionText readText = await recognizeText.processImage(ourImage);

  List<String> words = List();

  String taxNumber = "";

  for (TextBlock block in readText.blocks)
    for (TextLine line in block.lines)
      for (TextElement word in line.elements) words.add(word.text);

  outerLoop:
  for (int i = 0; i < words.length; i++) {
    print(words[i]);
    if (words[i].startsWith("V")) {
      print("StartsWithV: ${words[i]}");
      if (words[i].contains(".D")) {
        print("1: V.D");
        taxNumber += words[i].substring(4, words[i].length);
        print("Tax Number: $taxNumber");

        for (int j = i + 1; j < i + 4; j++) {
          isAdded = await taxCheck(taxNumber, isAdded);
          if (isAdded) break outerLoop;
          taxNumber += words[j];
          print("Tax Number: $taxNumber");
        }
      } else if (words[i].contains(".N")) {
        print("2: V.N");
        taxNumber += words[i].substring(4, words[i].length);
        print("Tax Number: $taxNumber");

        for (int j = i + 1; j < i + 4; j++) {
          isAdded = await taxCheck(taxNumber, isAdded);
          if (isAdded) break outerLoop;
          taxNumber += words[j];
          print("Tax Number: $taxNumber");
        }
        taxNumber += words[i].substring(3, words[i].length - 1);
      } else if (words[i].contains("ERG")) {
        print("3: VERG");
        taxNumber += words[i].substring(4, words[i].length);
        print("Tax Number: $taxNumber");

        for (int j = i + 1; j < i + 4; j++) {
          isAdded = await taxCheck(taxNumber, isAdded);
          if (isAdded) break outerLoop;
          taxNumber += words[j];
          print("Tax Number: $taxNumber");
        }
      } else if (words[i].contains("ER")) {
        print("4. VER");
        taxNumber += words[i].substring(4, words[i].length);
        print("Tax Number: $taxNumber");

        for (int j = i + 1; j < i + 4; j++) {
          isAdded = await taxCheck(taxNumber, isAdded);
          if (isAdded) break outerLoop;
          taxNumber += words[j];
          print("Tax Number: $taxNumber");
        }
      } else
        continue;
    }
  }

  print("Tax Number: $taxNumber");

  // outerLoop:
  // for (int i = index; i < words.length; i++) {
  //   Iterable<Match> taxNums = taxNumRegEx.allMatches(words[i]);
  //   if (taxNums != null) {
  //     for (var j in taxNums) {
  //       tax = j.group(0);
  //       print("Tax number: $tax");
  //       await DBProvider.db
  //           .newVoucher(Voucher(firstName: "DOCUART", lastName: tax));
  //       isAdded = true;
  //       break outerLoop;
  //     }
  //   }
  // }

  // outerLoop:
  // for (TextBlock block in readText.blocks) {
  //   for (TextLine line in block.lines) {
  //     Iterable<Match> taxNums = taxNumRegEx.allMatches(line.text);
  //     if (taxNums != null) {
  //       for (var a in taxNums) {
  //         tax = a.group(0);
  //         //print("First regex: $tax");
  //         await DBProvider.db
  //             .newVoucher(Voucher(firstName: "DOCUART", lastName: tax));
  //         isAdded = true;
  //         break outerLoop;
  //       }
  //     }
  //   }
  // }

  // if (tempText.isEmpty) {
  //   await DBProvider.db.newVoucher(
  //       Voucher(firstName: "[Company Name]", lastName: "[Tax Number]"));
  // } else
  //   await DBProvider.db
  //       .newVoucher(Voucher(firstName: "[Company Name]", lastName: tempText));

  if (!isAdded)
    await DBProvider.db.newReceipt(
        Receipt(firstName: "[Company Name]", lastName: "[Tax Number]"));
}

Future<bool> taxCheck(String taxNumber, bool isAdded) async {
  if (taxNumber.length == 10) {
    await DBProvider.db
        .newReceipt(Receipt(firstName: "DOCUART", lastName: taxNumber));
    isAdded = true;
  }
  return isAdded;
}

class Temp {
  final File imageFile;

  const Temp({Key key, this.imageFile});

  _operations(File image) async {
    if (image != null) {
      await _img2Text(image);
    } else {}
  }

  _img2Text(image) async {
    bool isAdded = false;

    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    List<String> words = List();

    String taxNumber = "";

    for (TextBlock block in readText.blocks)
      for (TextLine line in block.lines)
        for (TextElement word in line.elements) words.add(word.text);

    outerLoop:
    for (int i = 0; i < words.length; i++) {
      print(words[i]);
      if (words[i].startsWith("V")) {
        print("StartsWithV: ${words[i]}");
        if (words[i].contains(".D")) {
          print("1: V.D");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
        } else if (words[i].contains(".N")) {
          print("2: V.N");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
          taxNumber += words[i].substring(3, words[i].length - 1);
        } else if (words[i].contains("ERG")) {
          print("3: VERG");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
        } else if (words[i].contains("ER")) {
          print("4. VER");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
        } else
          continue;
      }
    }

    print("Tax Number: $taxNumber");

    // outerLoop:
    // for (int i = index; i < words.length; i++) {
    //   Iterable<Match> taxNums = taxNumRegEx.allMatches(words[i]);
    //   if (taxNums != null) {
    //     for (var j in taxNums) {
    //       tax = j.group(0);
    //       print("Tax number: $tax");
    //       await DBProvider.db
    //           .newVoucher(Voucher(firstName: "DOCUART", lastName: tax));
    //       isAdded = true;
    //       break outerLoop;
    //     }
    //   }
    // }

    // outerLoop:
    // for (TextBlock block in readText.blocks) {
    //   for (TextLine line in block.lines) {
    //     Iterable<Match> taxNums = taxNumRegEx.allMatches(line.text);
    //     if (taxNums != null) {
    //       for (var a in taxNums) {
    //         tax = a.group(0);
    //         //print("First regex: $tax");
    //         await DBProvider.db
    //             .newVoucher(Voucher(firstName: "DOCUART", lastName: tax));
    //         isAdded = true;
    //         break outerLoop;
    //       }
    //     }
    //   }
    // }

    // if (tempText.isEmpty) {
    //   await DBProvider.db.newVoucher(
    //       Voucher(firstName: "[Company Name]", lastName: "[Tax Number]"));
    // } else
    //   await DBProvider.db
    //       .newVoucher(Voucher(firstName: "[Company Name]", lastName: tempText));

    if (!isAdded)
      await DBProvider.db.newReceipt(
          Receipt(firstName: "[Company Name]", lastName: "[Tax Number]"));
  }

  Future<bool> taxCheck(String taxNumber, bool isAdded) async {
    if (taxNumber.length == 10) {
      await DBProvider.db
          .newReceipt(Receipt(firstName: "DOCUART", lastName: taxNumber));
      isAdded = true;
    }
    return isAdded;
  }
}

class ReadText extends StatefulWidget {
  final File imageFile;

  const ReadText({Key key, this.imageFile}) : super(key: key);

  @override
  _ReadTextState createState() => _ReadTextState();
}

class _ReadTextState extends State<ReadText> {
  bool loading = true;

  @override
  void initState() {
    _operations(widget.imageFile);
    super.initState();
  }

  _operations(File image) async {
    if (image != null) {
      setState(() => loading = true);
      await _img2Text(image);
    } else
      Navigator.pop(context);
    setState(() => loading = false);
  }

  _img2Text(image) async {
    bool isAdded = false;

    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    List<String> words = List();

    String taxNumber = "";

    for (TextBlock block in readText.blocks)
      for (TextLine line in block.lines)
        for (TextElement word in line.elements) words.add(word.text);

    outerLoop:
    for (int i = 0; i < words.length; i++) {
      print(words[i]);
      if (words[i].startsWith("V")) {
        print("StartsWithV: ${words[i]}");
        if (words[i].contains(".D")) {
          print("1: V.D");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
        } else if (words[i].contains(".N")) {
          print("2: V.N");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
          taxNumber += words[i].substring(3, words[i].length - 1);
        } else if (words[i].contains("ERG")) {
          print("3: VERG");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
        } else if (words[i].contains("ER")) {
          print("4. VER");
          taxNumber += words[i].substring(4, words[i].length);
          print("Tax Number: $taxNumber");

          for (int j = i + 1; j < i + 4; j++) {
            isAdded = await taxCheck(taxNumber, isAdded);
            if (isAdded) break outerLoop;
            taxNumber += words[j];
            print("Tax Number: $taxNumber");
          }
        } else
          continue;
      }
    }

    print("Tax Number: $taxNumber");

    // outerLoop:
    // for (int i = index; i < words.length; i++) {
    //   Iterable<Match> taxNums = taxNumRegEx.allMatches(words[i]);
    //   if (taxNums != null) {
    //     for (var j in taxNums) {
    //       tax = j.group(0);
    //       print("Tax number: $tax");
    //       await DBProvider.db
    //           .newVoucher(Voucher(firstName: "DOCUART", lastName: tax));
    //       isAdded = true;
    //       break outerLoop;
    //     }
    //   }
    // }

    // outerLoop:
    // for (TextBlock block in readText.blocks) {
    //   for (TextLine line in block.lines) {
    //     Iterable<Match> taxNums = taxNumRegEx.allMatches(line.text);
    //     if (taxNums != null) {
    //       for (var a in taxNums) {
    //         tax = a.group(0);
    //         //print("First regex: $tax");
    //         await DBProvider.db
    //             .newVoucher(Voucher(firstName: "DOCUART", lastName: tax));
    //         isAdded = true;
    //         break outerLoop;
    //       }
    //     }
    //   }
    // }

    // if (tempText.isEmpty) {
    //   await DBProvider.db.newVoucher(
    //       Voucher(firstName: "[Company Name]", lastName: "[Tax Number]"));
    // } else
    //   await DBProvider.db
    //       .newVoucher(Voucher(firstName: "[Company Name]", lastName: tempText));

    if (!isAdded)
      await DBProvider.db.newReceipt(
          Receipt(firstName: "[Company Name]", lastName: "[Tax Number]"));
  }

  Future<bool> taxCheck(String taxNumber, bool isAdded) async {
    if (taxNumber.length == 10) {
      await DBProvider.db
          .newReceipt(Receipt(firstName: "DOCUART", lastName: taxNumber));
      isAdded = true;
    }
    return isAdded;
  }

  @override
  Widget build(BuildContext context) {
    Navigator.pop(context);
    return Loading();
  }
}
