import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_scanner/shared/constants.dart';
import 'package:receipt_scanner/services/read_text.dart';

// Future pickImage(context, source) async {
//     // ignore: deprecated_member_use
//     File tempFile = await ImagePicker.pickImage(
//       source: source,
//     );
//     File croppedFile = await ImageCropper.cropImage(
//       sourcePath: tempFile.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       androidUiSettings: AndroidUiSettings(
//           toolbarTitle: 'Crop Fish',
//           statusBarColor: kPalette2,
//           toolbarColor: kPalette2,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false),
//     );

//     bool done = await operations(croppedFile);

//                   if (done)
//                     print("successful");
//                   else
//                     print("unsuccessful");

//                   setState(() {
//                     widget.bloc.changeNavigationIndex(Navigation.DATA);
//                   });
//                   Navigator.popUntil(context, ModalRoute.withName('/'));
//   }

// class PickReceipt extends StatefulWidget {
//   @override
//   _PickReceiptState createState() => _PickReceiptState();
// }

// class _PickReceiptState extends State<PickReceipt> {
//   Future pickImage(context, source) async {
//     // ignore: deprecated_member_use
//     var tempFile = await ImagePicker.pickImage(
//       source: source,
//     );
//   }

// _cropImage(picture) async {
//   File croppedFile = await ImageCropper.cropImage(
//     sourcePath: picture.path,
//     aspectRatioPresets: [
//       CropAspectRatioPreset.square,
//       CropAspectRatioPreset.ratio3x2,
//       CropAspectRatioPreset.original,
//       CropAspectRatioPreset.ratio4x3,
//       CropAspectRatioPreset.ratio16x9
//     ],
//     androidUiSettings: AndroidUiSettings(
//         toolbarTitle: 'Crop Fish',
//         statusBarColor: kPalette2,
//         toolbarColor: kPalette2,
//         toolbarWidgetColor: Colors.white,
//         initAspectRatio: CropAspectRatioPreset.original,
//         lockAspectRatio: false),
//   );
//     // TODO: Push to read_text.dart
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
