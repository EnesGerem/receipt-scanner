import 'package:flutter/material.dart';
import 'package:receipt_scanner/controllers/navigation/navigation.dart';
import 'package:receipt_scanner/database/local_database.dart';
import 'package:receipt_scanner/services/excel_operations.dart';
import 'package:receipt_scanner/shared/loading.dart';

class SendMail extends StatefulWidget {
  final NavigationBloc bloc;

  const SendMail({Key key, this.bloc}) : super(key: key);
  @override
  _SendMailState createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  bool loading = true;

  _submitForm() async {
    await putExcelandSend(await DBProvider.db.getAllReceipts());
    await DBProvider.db
        .getAllReceipts()
        .then((value) => value.forEach((element) {
              DBProvider.db.deleteReceipt(element.id);
            }));
  }

  @override
  void initState() {
    _submitForm();

    setState(() {
      widget.bloc.changeNavigationIndex(Navigation.HOMEPAGE);
    });
    loading = false;
    Navigator.popUntil(context, ModalRoute.withName('/'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Container();
  }
}
