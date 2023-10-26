import 'dart:io';
import 'dart:typed_data';

import 'package:alcohol_inventory/screens/profile/inventory_items_view.dart';
import 'package:alcohol_inventory/services/storage_service.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import '../../utils/theme.dart';

class UploadReport extends StatefulWidget {
  const UploadReport({super.key});
  static const String routePath = '/uploadReport';

  @override
  State<UploadReport> createState() => _UploadReportState();
}

class _UploadReportState extends State<UploadReport> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;

  int selectedIndex = -1;
  String? selectedNameColumn;
  String? selectedQtyColumn;
  List<Data?>? header;
  Set<String?> drinkList = {};
  File? file;
  bool isReadingItem = false;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Report Template',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(InventoryItemView.routePath);
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: header?.isEmpty ?? true,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'xlsx',
                      'xlsm',
                      'xlsb',
                      'xltx',
                      'xls',
                    ],
                  );

                  if (result != null) {
                    file = File(result.files.single.path ?? '');
                    if (file == null) return;
                    Uint8List bytes = file!.readAsBytesSync();
                    Excel excel = Excel.decodeBytes(bytes);
                    Sheet sheet = excel.tables.entries.elementAt(0).value;
                    setState(() {
                      header = sheet.rows.first;
                    });
                  } else {
                    // User canceled the picker
                  }
                },
                child: const Text('Browse report template'),
              ),
            ),
          ),
          Visibility(
            visible: (header?.isNotEmpty ?? false) &&
                (selectedNameColumn?.isEmpty ?? true),
            child: Text(
                'We have detected ${header?.length ?? 0} columns in your selected sheet. Pick the column for name and quantity'),
          ),
          Visibility(
            visible: (header?.isNotEmpty ?? false) &&
                (selectedNameColumn?.isEmpty ?? true),
            child: verticalGap(defaultPadding / 2),
          ),
          Visibility(
            visible: (header?.isNotEmpty ?? false) &&
                (selectedNameColumn?.isEmpty ?? true),
            child: Expanded(
              child: ListView.separated(
                itemCount: header?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    // value: index,
                    // groupValue: selectedIndex,
                    // onChanged: (value) {
                    //   setState(() {
                    //     selectedIndex = value ?? -1;
                    //   });
                    // },
                    trailing: PopupMenuButton(
                      child: const Icon(Icons.add),
                      itemBuilder: (_) => const <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                            value: 'name', child: Text('Set as Name column')),
                        PopupMenuItem<String>(
                            value: 'qty',
                            child: Text('Set as Quantity column')),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'name':
                            selectedIndex = index;
                            SnackBarService.instance
                                .showSnackBarInfo('Name column selected');
                            break;
                          case 'qty':
                            selectedQtyColumn =
                                '${header?.elementAt(index)?.value ?? ''}';
                            SnackBarService.instance
                                .showSnackBarInfo('Quantity column selected');
                            break;
                        }
                      },
                    ),

                    title: Text('${header?.elementAt(index)?.value ?? ''}'),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: dividerColor,
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: (header?.isNotEmpty ?? false) &&
                (selectedNameColumn?.isEmpty ?? true),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isReadingItem
                    ? null
                    : () async {
                        selectedNameColumn =
                            header?.elementAt(selectedIndex)?.value.toString();
                        if (selectedNameColumn == selectedQtyColumn) {
                          SnackBarService.instance.showSnackBarError(
                              'Name and Quantity column cannot be same');
                          return;
                        }
                        if ((selectedNameColumn?.trim().isEmpty ?? true) ||
                            (selectedQtyColumn?.trim().isEmpty ?? true)) {
                          SnackBarService.instance.showSnackBarError(
                              'Name or Quantity column cannot be empty');
                          return;
                        }
                        setState(() {
                          isReadingItem = true;
                        });

                        Uint8List bytes = file!.readAsBytesSync();
                        Excel excel = Excel.decodeBytes(bytes);
                        Sheet sheet = excel.tables.entries.elementAt(0).value;
                        for (var i = 1; i < sheet.rows.length; i++) {
                          var cellValue = sheet
                              .cell(CellIndex.indexByColumnRow(
                                  columnIndex: selectedIndex, rowIndex: i))
                              .value
                              .toString();
                          String drink =
                              cellValue is String && cellValue != null
                                  ? cellValue.toString().trim()
                                  : '';
                          debugPrint('${i},${selectedIndex} : ${drink}');
                          drinkList.add(drink);
                        }
                        setState(() {
                          isReadingItem = false;
                        });
                      },
                child: Text(
                  isReadingItem ? 'Please wait...' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Visibility(
            visible: drinkList.isNotEmpty,
            child: Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'We have parsed ${drinkList.length}. Do you want to save?'),
                    ),
                    children: [
                      for (String? e in drinkList) ...{
                        Text('$e'),
                      }
                    ],
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: drinkList.isNotEmpty,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _firestore.status == FirestoreStatus.loading
                    ? null
                    : () async {
                        if (await _firestore.addInventoryItem(
                                _auth.user?.uid ?? '', drinkList) ??
                            false) {
                          String downloadLink =
                              await StorageService.uploadReportSheet(file!);
                          await _firestore
                              .updateUserPartially(_auth.user?.uid ?? '', {
                            'nameColumn': selectedNameColumn,
                            'qtyColumn': selectedQtyColumn,
                            'reportSheet': downloadLink,
                          });
                          SnackBarService.instance
                              .showSnackBarSuccess('Items save.');
                          Navigator.pop(context);
                        }
                      },
                child: Text(_firestore.status == FirestoreStatus.loading
                    ? 'Saving, please wait'
                    : 'Save'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
