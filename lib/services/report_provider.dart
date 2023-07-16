import 'dart:developer';
import 'dart:io';

import 'package:alcohol_inventory/models/history_model.dart';
import 'package:alcohol_inventory/services/firestore_service.dart';
import 'package:alcohol_inventory/services/snackbar_service.dart';
import 'package:alcohol_inventory/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../models/inventory_model.dart';

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
      final Worksheet inventorySheet = workbook.worksheets[1];
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
      File('$filePath/Report_${DateTime.now().toString().replaceAll(':', '').replaceAll(' ', '')}.xlsx')
          .writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }
}
