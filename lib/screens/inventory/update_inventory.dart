import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inventory_model.dart';
import '../../services/api_provider.dart';
import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/date_time_formatter.dart';
import '../../utils/enum.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/primary_button.dart';

class UpdateInventoryScreen extends StatefulWidget {
  const UpdateInventoryScreen({super.key, required this.barcode});
  static const String routePath = '/updateInventoryScreen';
  final String barcode;

  @override
  State<UpdateInventoryScreen> createState() => _UpdateInventoryScreenState();
}

class _UpdateInventoryScreenState extends State<UpdateInventoryScreen> {
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
        loadScreen();
      },
    );
  }

  loadScreen() async {
    inventoryItem = await _firestore.getInventoryByUpc(
        _auth.user?.uid ?? '', widget.barcode);
    setState(() {});
  }

  final TextEditingController _qtyCtrl = TextEditingController();
  double qty = 0.0;
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  late ApiProvider _api;

  InventoryModel? inventoryItem;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
      ),
      body: _api.status == ApiStatus.loading ||
              _firestore.status == FirestoreStatus.loading
          ? showLoader(context)
          : inventoryItem != null
              ? showBody(context)
              : const Center(
                  child: Text('Item not found'),
                ),
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
        getHorizontalRowItem(
          context,
          'UPC code',
          '${inventoryItem?.item?.upc ?? 0}',
        ),
        getHorizontalRowItem(
          context,
          'Total',
          '${inventoryItem?.quanty ?? 0}',
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
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
              desc: 'You are updating the quanty by $qty',
              onDismissCallback: (type) {},
              autoDismiss: false,
              btnOkOnPress: () {
                FocusManager.instance.primaryFocus?.unfocus();

                inventoryItem?.lastUpdateTime = Timestamp.now();
                inventoryItem?.updateValue = qty;
                inventoryItem?.quanty = qty + (inventoryItem?.quanty ?? 0);

                inventoryItem?.updateType = qty < 0
                    ? ModificationType.removed.name
                    : ModificationType.restocked.name;

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
          isDisabled: _api.status == ApiStatus.loading ||
              _firestore.status == FirestoreStatus.loading,
          isLoading: _api.status == ApiStatus.loading ||
              _firestore.status == FirestoreStatus.loading,
        ),
      ],
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
}
