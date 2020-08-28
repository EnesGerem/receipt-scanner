import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:receipt_scanner/controllers/navigation/navigation.dart';
import 'package:receipt_scanner/database/local_database.dart';
import 'package:receipt_scanner/models/receipt.dart';
import 'package:receipt_scanner/services/excel_operations.dart';
import 'package:receipt_scanner/services/scan.dart';
import 'package:receipt_scanner/shared/constants.dart';
import 'package:receipt_scanner/shared/loading.dart';

class Data extends StatefulWidget {
  final CameraDescription camera;
  final NavigationBloc bloc;

  const Data({Key key, this.camera, this.bloc}) : super(key: key);
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  _submitForm() async {
    await putExcelandSend(await DBProvider.db.getAllReceipts());
    await DBProvider.db
        .getAllReceipts()
        .then((value) => value.forEach((element) {
              DBProvider.db.deleteReceipt(element.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    Future allData = DBProvider.db.getAllReceipts();
    Size size = MediaQuery.of(context).size;
    GlobalKey<ScaffoldState> _key = GlobalKey();
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            key: _key,
            body: Stack(
              children: [
                FutureBuilder<List<Receipt>>(
                  future: allData,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Receipt>> snapshot) {
                    if (snapshot.hasData)
                      return Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.12),
                        child: buildDBListView(snapshot, _key, size),
                      );
                    else
                      return Center(child: CircularProgressIndicator());
                  },
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       vertical: size.height * 0.03, horizontal: size.width * 0.06),
                //   child: Align(
                //     alignment: Alignment.bottomRight,
                //     child: FloatingActionButton(
                //       child: Icon(
                //         Icons.mail,
                //         color: Colors.white,
                //         size: 30,
                //       ),
                //       onPressed: () async {
                //         // setState(() => loading = true);
                //         await _submitForm();

                //         Navigator.popUntil(context, ModalRoute.withName('/'));
                //       },
                //       backgroundColor: kPalette2,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.06),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          heroTag: "btn1",
                          child: Icon(
                            Icons.send,
                            color: kPalette2,
                            size: 30,
                          ),
                          onPressed: () async {
                            setState(() => loading = true);

                            await _submitForm();

                            setState(() {
                              loading = false;

                              widget.bloc
                                  .changeNavigationIndex(Navigation.HOMEPAGE);
                            });
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             SendMail(bloc: widget.bloc)));
                          },
                          backgroundColor: Colors.white,
                        ),
                        FloatingActionButton(
                          heroTag: "btn2",
                          child: Icon(
                            Icons.note_add,
                            color: kPalette2,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scan(
                                        camera: widget.camera,
                                        bloc: widget.bloc)));
                          },
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  ListView buildDBListView(AsyncSnapshot<List<Receipt>> snapshot,
      GlobalKey<ScaffoldState> _key, Size size) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        Receipt item = snapshot.data[index];
        return Dismissible(
          direction: DismissDirection.endToStart,
          key: UniqueKey(),
          background: Container(
            color: kAppBlue,
            child: Padding(
              padding: EdgeInsets.only(left: size.width * 0.8),
              child: Icon(Icons.delete,
                  size: size.height * 0.04, color: Colors.white),
            ),
          ),
          onDismissed: (direction) {
            //TODO: Dissmisible objeyi geri getir
            /*setState(() {
              dynamic deleted = DBProvider.db.getVoucher(item.id);
              DBProvider.db.deleteVoucher(item.id);
              _key.currentState
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text("Deleted \"$deleted\""),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        setState(() {
                          // DBProvider.db.newVoucher(Voucher(
                          //     id: deleted.id,
                          //     firstName: deleted.firstName,
                          //     lastName: deleted.lastName));
                        });
                      },
                    ),
                  ),
                );
            });*/
            //dynamic deleted = DBProvider.db.getVoucher(item.id);
            dynamic deletedData = DBProvider.db.deleteReceipt(item.id);
            setState(() {
              var deleted = snapshot.data.removeAt(index);

              _key.currentState
                ..showSnackBar(
                  SnackBar(
                    content: Text("Deleted \"$deleted\""),
                    action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          DBProvider.db.newReceipt(Receipt(
                              id: deletedData.id,
                              firstName: deletedData.firstName,
                              lastName: deletedData.lastName));
                          setState(() {
                            snapshot.data.insert(index, deleted);
                          });
                        }),
                  ),
                );
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/icon/receipt_logo.png", scale: 15),
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Company Name",
                              style: TextStyle(
                                fontFamily: "Spartan-Bold",
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            "${item.firstName}",
                            style: TextStyle(
                                fontFamily: kDefaultFontFamily,
                                color: kPalette2),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Tax Number",
                              style: TextStyle(
                                fontFamily: "Spartan-Bold",
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            "${item.lastName}",
                            style: TextStyle(
                                fontFamily: kDefaultFontFamily,
                                color: kPalette2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
