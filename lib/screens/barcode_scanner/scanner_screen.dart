import 'dart:developer';

import 'package:alcohol_inventory/models/inventory_model.dart';
import 'package:alcohol_inventory/models/upc_response_model.dart';
import 'package:alcohol_inventory/services/api_provider.dart';
import 'package:alcohol_inventory/utils/api.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/date_time_formatter.dart';
import 'package:alcohol_inventory/utils/enum.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:alcohol_inventory/widgets/primary_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.switchTabs});
  final Function(int) switchTabs;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextEditingController _qtyCtrl = TextEditingController();
  double qty = 0.0;
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  late ApiProvider _api;
  UpcResponseModel? upcResponse;
  InventoryModel? inventoryItem;
  bool isItemNewToInventory = false;

  @override
  void initState() {
    super.initState();

    _qtyCtrl.text = qty.toString();

    _qtyCtrl.addListener(() {
      if (_qtyCtrl.text.isNotEmpty) {
        try {
          double val = double.parse(_qtyCtrl.text);
          setState(() {
            qty = val;
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _firestore.status = FirestoreStatus.ideal;
        _api.status = ApiStatus.ideal;
        _auth.status = AuthStatus.notAuthenticated;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: _api.status == ApiStatus.loading ||
              _firestore.status == FirestoreStatus.loading
          ? showLoader(context)
          : _api.status == ApiStatus.success &&
                  _firestore.status == FirestoreStatus.success &&
                  inventoryItem != null
              ? showBody(context)
              : showScannerPrompt(context),
    );
  }

  showBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          '${inventoryItem?.item?.title}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        verticalGap(defaultPadding),
        Card(
          elevation: defaultPadding / 2,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: '${inventoryItem?.item?.images?.first}',
                    placeholder: (context, url) => Image.asset(
                      'assets/logo/loading.gif',
                      width: 100,
                    ),
                    errorWidget: (context, url, error) => SvgPicture.asset(
                      'assets/svg/notfound.svg',
                      width: 100,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    defaultPadding,
                    defaultPadding,
                    defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getItemDetailRow(
                          context, 'UPC', "${inventoryItem?.item?.upc}"),
                      verticalGap(defaultPadding / 2),
                      getItemDetailRowWithReadmore(context, 'DESCRIPTION',
                          "${inventoryItem?.item?.description}"),
                      verticalGap(defaultPadding / 2),
                      getItemDetailRow(
                          context, 'BRAND', "${inventoryItem?.item?.brand}"),
                      verticalGap(defaultPadding / 2),
                      getItemDetailRow(
                          context, 'QUANTITY', "${inventoryItem?.quanty ?? 0}")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        verticalGap(
          defaultPadding * 2,
        ),
        Text(
          'INVENTORY OVERVIEW',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        verticalGap(
          defaultPadding,
        ),
        getHorizontalRowItem(
          context,
          'Last updated quantity',
          '${inventoryItem?.updateValue ?? 0}',
        ),
        getHorizontalRowItem(
          context,
          'Last updated on',
          DateTimeFormatter.formatDate(inventoryItem?.lastUpdateTime),
        ),
        verticalGap(
          defaultPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        qty -= 0.5;
                        setState(() {
                          _qtyCtrl.text = qty.toString();
                          _qtyCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: _qtyCtrl.text.length));
                        });
                      },
                      child: decrementButton(context),
                    ),
                    SizedBox(
                      height: 45,
                      width: 70,
                      child: TextField(
                        controller: _qtyCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        qty += 0.5;
                        setState(() {
                          _qtyCtrl.text = qty.toString();
                          _qtyCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: _qtyCtrl.text.length));
                        });
                      },
                      child: incrementButton(context),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        verticalGap(defaultPadding),
        PrimaryButton(
          onPressed: () {
            if (qty == 0) {
              SnackBarService.instance
                  .showSnackBarInfo('Quantity to be updated can not be 0');
              return;
            }
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              animType: AnimType.bottomSlide,
              title: 'Are you sure?',
              desc: 'You are updating the quanty to $qty',
              onDismissCallback: (type) {},
              autoDismiss: false,
              btnOkOnPress: () {
                FocusManager.instance.primaryFocus?.unfocus();

                inventoryItem?.lastUpdateTime = Timestamp.now();
                inventoryItem?.updateValue = qty;
                inventoryItem?.quanty = qty + (inventoryItem?.quanty ?? 0);
                if (!isItemNewToInventory) {
                  inventoryItem?.updateType = qty < 0
                      ? ModificationType.removed.name
                      : ModificationType.restocked.name;
                }
                _firestore
                    .updateInventory(_auth.user!.uid, inventoryItem!.item!.upc!,
                        inventoryItem!)
                    .then((value) {
                  setState(() {
                    _firestore.status = FirestoreStatus.ideal;
                    _api.status = ApiStatus.ideal;
                    _auth.status = AuthStatus.notAuthenticated;
                  });
                });
                Navigator.of(context).pop();
              },
              btnOkColor: primaryColor,
              btnCancelOnPress: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.of(context).pop();
              },
            ).show();
          },
          label: 'Update',
          isDisabled: false,
          isLoading: false,
        ),
        TextButton(
          onPressed: () async {
            await FlutterBarcodeScanner.scanBarcode(
                    '#0B4F86', 'Cancel', true, ScanMode.BARCODE)
                .then((barcode) {
              fetchFromUpc(barcode);
            });
          },
          child: const Text('Scan more'),
        )
      ],
    );
  }

  Row getHorizontalRowItem(BuildContext context, String key, String value) {
    return Row(
      children: [
        Text(
          key,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: hintColor,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
        )
      ],
    );
  }

  Container incrementButton(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.6),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Text(
        '+',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: textColorDark),
      ),
    );
  }

  Container decrementButton(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.6),
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      alignment: Alignment.center,
      child: Text(
        '-',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: textColorDark),
      ),
    );
  }

  RichText getItemDetailRow(BuildContext context, String key, String value) {
    return RichText(
      text: TextSpan(
        text: '$key\n',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: hintColor,
              fontWeight: FontWeight.bold,
            ),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColorDark,
                ),
          ),
        ],
      ),
    );
  }

  showScannerPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/barcode-scanners-placeholder.png',
            width: 200,
            height: 200,
          ),
          verticalGap(defaultPadding),
          ElevatedButton(
            onPressed: () async {
              await FlutterBarcodeScanner.scanBarcode(
                      '#0B4F86', 'Cancel', true, ScanMode.BARCODE)
                  .then((barcode) {
                // fetchFromUpc(barcode);
                fetchFromUpc('0088110150556');
              });
            },
            child: const Text('Scan Barcode'),
          )
        ],
      ),
    );
  }

  showLoader(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo/loading.gif',
            width: 100,
            height: 100,
          ),
          verticalGap(defaultPadding),
          Text(
            'Fetching details, please wait...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  void fetchFromUpc(String barcode) async {
    isItemNewToInventory = false;
    upcResponse = await _api.getItemByUpc(barcode);

    if (upcResponse != null &&
        upcResponse?.code == Api.ok &&
        (upcResponse?.items?.isNotEmpty ?? false)) {
      inventoryItem = await _firestore.getInventoryByUpc(
          _auth.user?.uid ?? '', upcResponse?.items?.first.upc ?? '');
      if (inventoryItem != null && inventoryItem?.item != null) {
        SnackBarService.instance.showSnackBarSuccess(
            'Item found. Current quantity : ${inventoryItem?.quanty}');
        isItemNewToInventory = false;
      } else {
        SnackBarService.instance
            .showSnackBarInfo('You are about to load new item');
        isItemNewToInventory = true;
        inventoryItem?.updateType = ModificationType.stocked.name;
      }
      setState(() {
        inventoryItem?.item = upcResponse?.items?.first;
      });
    } else {
      log('$barcode not present in UPC');
      SnackBarService.instance.showSnackBarError('$barcode not present in UPC');
    }
  }

  getItemDetailRowWithReadmore(BuildContext context, String key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          key,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        ReadMoreText(
          value,
          trimLines: 2,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: textColorDark,
              ),
          colorClickableText: primaryColor,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: '   Show less',
        ),
      ],
    );
  }
}
