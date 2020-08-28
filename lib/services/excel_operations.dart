import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receipt_scanner/models/receipt.dart';
import 'package:receipt_scanner/services/mail.dart';

putExcelandSend(List<Receipt> list) async {
  Excel excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  var path = (await getApplicationDocumentsDirectory()).path;
  var filepath = join(path, 'new.xlsx');

  int row = 0;
  int column = 0;

  for (var i = 0; i < list.length; i++) {
    sheet
        .cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: column++))
        .value = list[i].id.toString();
    sheet
        .cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: column++))
        .value = list[i].firstName.toString();
    sheet
        .cell(CellIndex.indexByColumnRow(rowIndex: row++, columnIndex: column))
        .value = list[i].lastName.toString();

    column = 0;

    if (i == list.length - 1) {
      for (var table in excel.tables.keys) {
        print(table);
        print(excel.tables[table].maxCols);
        print(excel.tables[table].maxRows);
        for (var row in excel.tables[table].rows) print("$row");
      }

      var outputFile = filepath;
      excel.encode().then((onValue) {
        File(join(outputFile))
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue, mode: FileMode.write);
      });
      await sendMail(File(filepath));
    }
  }
}
