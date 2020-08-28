import 'package:flutter/material.dart';
import 'package:receipt_scanner/controllers/navigation/navigation.dart';
import 'package:receipt_scanner/database/local_database.dart';
import 'package:receipt_scanner/models/receipt.dart';
import 'package:receipt_scanner/shared/constants.dart';

class Data extends StatefulWidget {
  final NavigationBloc bloc;

  const Data({Key key, this.bloc}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    Future allData = DBProvider.db.getAllReceipts();
    Size size = MediaQuery.of(context).size;
    GlobalKey<ScaffoldState> _key = GlobalKey();
    return Scaffold(
      key: _key,
      body: Padding(
        padding:
            EdgeInsets.fromLTRB(0, size.height * 0.15, 0, size.height * 0.045),
        child: FutureBuilder<List<Receipt>>(
          future: allData,
          builder:
              (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
            if (snapshot.hasData)
              return buildDBListView(snapshot, _key);
            else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  ListView buildDBListView(
      AsyncSnapshot<List<Receipt>> snapshot, GlobalKey<ScaffoldState> _key) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        Receipt item = snapshot.data[index];
        return Dismissible(
          key: UniqueKey(),
          background: Container(color: kPalette2),
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
          // child: ListTile(
          //   title: Text(
          //     "${item.firstName}\t${item.lastName}",
          //     style: TextStyle(
          //       fontFamily: "Spartan-Medium",
          //       fontSize: 15,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   leading: Image.asset("assets/icon/voucher_logo.png", scale: 15),
          // ),
          child: Card(
            color: Colors.white,
            elevation: 0,
            child: Row(
              children: <Widget>[
                Image.asset("assets/icon/voucher_logo.png", scale: 15),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 2, 0, 0),
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
                            fontFamily: kDefaultFontFamily, color: kPalette2),
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
                            fontFamily: kDefaultFontFamily, color: kPalette2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
