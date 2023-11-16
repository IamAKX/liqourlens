import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alcohol_inventory/models/history_model.dart';
import 'package:alcohol_inventory/services/firestore_service.dart';
import 'package:alcohol_inventory/services/snackbar_service.dart';
import 'package:alcohol_inventory/utils/date_time_formatter.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../models/inventory_model.dart';
import '../models/user_profile.dart';

enum ReportGeneratorStatus { ideal, loading, success, failed }

class ReportGeneratorProvider extends ChangeNotifier {
  ReportGeneratorStatus? status = ReportGeneratorStatus.ideal;
  String filePath = '';

  static ReportGeneratorProvider instance = ReportGeneratorProvider();

  Future<bool> generateInventoryReport(String userId) async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory()
          .then((dir) => filePath = dir.path);
    } else {
      // await getExternalStorageDirectory().then(
      //     (dir) => filePath = dir?.path ?? '/storage/emulated/0/Download');
      filePath = '/storage/emulated/0/Download';
    }
    SnackBarService.instance
        .showSnackBarInfo('Generating report, please wait...');

    status = ReportGeneratorStatus.loading;
    notifyListeners();
    try {
      List<InventoryModel> inventoryList = [];
      List<HistoryModel> historyList = [];
      await FirestoreProvider()
          .getAllItemsInInventory(userId)
          .then((value) => inventoryList = value);
      await FirestoreProvider()
          .getHistoryByUser(userId)
          .then((value) => historyList = value);

      List<String> inventoryListHeader = [
        'UPC',
        'Title',
        'Quantity',
        'Last Updated',
      ];
      List<String> historyListHeader = [
        'UPC',
        'Title',
        'Quantity',
        'Net Quantity',
        'Timestamp',
        'Action'
      ];
      final Workbook workbook = Workbook(2);
      Style globalStyle = workbook.styles.add('style');
      globalStyle.bold = true;

      // ** Start of inventory **
      final Worksheet inventorySheet = workbook.worksheets[0];
      inventorySheet.name = 'Inventory';
      for (var headerIndex = 0;
          headerIndex < inventoryListHeader.length;
          headerIndex++) {
        inventorySheet
            .getRangeByIndex(1, headerIndex + 1)
            .setText(inventoryListHeader.elementAt(headerIndex));
        inventorySheet.getRangeByIndex(1, headerIndex + 1).cellStyle =
            globalStyle;
      }
      for (var rIndex = 0; rIndex < inventoryList.length; rIndex++) {
        InventoryModel model = inventoryList.elementAt(rIndex);

        inventorySheet
            .getRangeByIndex(rIndex + 2, 1)
            .setText(model.item?.upc ?? '');

        inventorySheet
            .getRangeByIndex(rIndex + 2, 2)
            .setText(model.item?.title);
        inventorySheet
            .getRangeByIndex(rIndex + 2, 3)
            .setText('${model.quanty}');
        inventorySheet.getRangeByIndex(rIndex + 2, 4).setText(
            DateTimeFormatter.formatDateForReport(model.lastUpdateTime));
      }
      // ** End of inventory **

      // ** Start of history **
      final Worksheet historySheet = workbook.worksheets[1];
      historySheet.name = 'History';
      for (var headerIndex = 0;
          headerIndex < historyListHeader.length;
          headerIndex++) {
        historySheet
            .getRangeByIndex(1, headerIndex + 1)
            .setText(historyListHeader.elementAt(headerIndex));
        historySheet.getRangeByIndex(1, headerIndex + 1).cellStyle =
            globalStyle;
      }
      for (var rIndex = 0; rIndex < historyList.length; rIndex++) {
        HistoryModel model = historyList.elementAt(rIndex);

        historySheet.getRangeByIndex(rIndex + 2, 1).setText(model.upc ?? '');

        historySheet.getRangeByIndex(rIndex + 2, 2).setText(model.name);
        historySheet
            .getRangeByIndex(rIndex + 2, 3)
            .setText('${model.updateValue}');
        historySheet
            .getRangeByIndex(rIndex + 2, 4)
            .setText('${model.quantity}');
        historySheet.getRangeByIndex(rIndex + 2, 5).setText(
            DateTimeFormatter.formatDateForReport(model.lastUpdateTime));
        historySheet
            .getRangeByIndex(rIndex + 2, 6)
            .setText('${model.updateType?.toUpperCase()}');
      }
      // ** End of history **
      log('Saving to $filePath/Report_${DateTime.now()}.xlsx');
      final List<int> bytes = workbook.saveAsStream();
      String fname =
          '$filePath/Report_${DateTime.now().toString().replaceAll(':', '').replaceAll(' ', '')}.xlsx';
      File(fname).writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      OpenFile.open(fname).then((value) {
        SnackBarService.instance.showSnackBarInfo(value.message);
      });
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }

  Future<bool> generateInventoryReportV2(String userId) async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory()
          .then((dir) => filePath = dir.path);
    } else {
      filePath = '/storage/emulated/0/Download';
    }
    List<InventoryModel> inventoryList = [];
    UserProfile? userProfile;
    await FirestoreProvider()
        .getAllItemsInInventory(userId)
        .then((value) => inventoryList = value);
    await FirestoreProvider().getUserById(userId).then((value) {
      userProfile = value;
    });
    Map<String, double> itemQtyMap = {};
    inventoryList.forEach((element) {
      double qty = itemQtyMap[element.item?.title ?? ''] ?? 0.0;
      qty = qty + (element.quanty ?? 0);
      itemQtyMap[element.item?.title ?? ''] = qty;
    });
    String? sheetPath = await downloadFile(
        userProfile?.reportSheet ?? '', 'report.xlsx', filePath);

    log(sheetPath ?? 'no path');
    File file = File(sheetPath!);
    Uint8List bytes = file!.readAsBytesSync();
    Excel excel = Excel.decodeBytes(bytes);
    Sheet sheet = excel.tables.entries.elementAt(0).value;
    int nameColumnIndex = -1;
    int qtyColumnIndex = -1;
    List<Data?>? header = sheet.rows.first;
    for (var i = 0; i < header.length; i++) {
      if ('${header.elementAt(i)?.value ?? ''}' == userProfile?.nameColumn) {
        nameColumnIndex = i;
      }
      if ('${header.elementAt(i)?.value ?? ''}' == userProfile?.qtyColumn) {
        qtyColumnIndex = i;
      }
    }
    for (var i = 1; i < sheet.rows.length; i++) {
      String currentDrink = sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: nameColumnIndex, rowIndex: i))
          .value
          .toString();
      double inventoryQty = itemQtyMap[currentDrink] ?? 0;

      sheet.updateCell(
          CellIndex.indexByColumnRow(columnIndex: qtyColumnIndex, rowIndex: i),
          inventoryQty == 0 ? '' : inventoryQty);
    }
    var fileBytes = excel.save();

    String fname =
        '$filePath/Report_${DateTime.now().toString().replaceAll(':', '').replaceAll(' ', '')}.xlsx';
    File(p.join(fname))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    await file.delete();
    SnackBarService.instance.showSnackBarSuccess('Report generated');
    status = ReportGeneratorStatus.ideal;
    notifyListeners();
    OpenFile.open(fname).then((value) {
      SnackBarService.instance.showSnackBarInfo(value.message);
    });
    return true;
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url + '/' + fileName;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}
