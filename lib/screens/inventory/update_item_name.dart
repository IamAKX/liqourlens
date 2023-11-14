import 'dart:developer';

import 'package:alcohol_inventory/models/upc_item_model.dart';
import 'package:alcohol_inventory/screens/profile/upload_report.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/enum.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inventory_model.dart';
import '../../models/user_profile.dart';
import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import '../../utils/theme.dart';
import '../../widgets/input_field.dart';
import '../../widgets/primary_button.dart';

class UpdateItemNameScreen extends StatefulWidget {
  const UpdateItemNameScreen({super.key, required this.upcCode});
  static const String routePath = '/updateItemNameScreen';
  final String upcCode;

  @override
  State<UpdateItemNameScreen> createState() => _UpdateItemNameScreenState();
}

class _UpdateItemNameScreenState extends State<UpdateItemNameScreen> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  UserProfile? userProfile;
  bool isImageUploading = false;
  List<String> drinkList = [];
  final TextEditingController _upc = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  String liquorImage = '';

  List<String> added = [];
  String currentText = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _firestore.status = FirestoreStatus.ideal;

        loadScreen();
      },
    );
  }

  void loadScreen() {
    _firestore.getInventoryItem(_auth.user?.uid ?? '').then((value) {
      setState(() {
        drinkList = value ?? [];
        log(drinkList.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _firestore = Provider.of<FirestoreProvider>(context);
    _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Item Name',
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        InputField(
          hint: 'UPC',
          controller: TextEditingController(text: widget.upcCode),
          keyboardType: TextInputType.name,
          obscure: false,
          enabled: false,
          icon: Icons.liquor_outlined,
        ),
        verticalGap(defaultPadding),
        EasyAutocomplete(
          decoration: const InputDecoration(
            hintText: 'Title',
            filled: true,
            prefixIcon: Icon(
              Icons.liquor_outlined,
            ),
          ),
          controller: _title,
          suggestions: drinkList,
          onChanged: (value) {},
          onSubmitted: (value) {},
        ),
        verticalGap(defaultPadding),
        verticalGap(defaultPadding),
        Visibility(
            visible: drinkList.isEmpty,
            child: Text(
              'You have not loaded your drink repository. You cannot add new product.\n',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            )),
        Visibility(
          visible: drinkList.isEmpty,
          child: PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, UploadReport.routePath)
                    .then((value) => loadScreen());
              },
              label: 'Load drink repository',
              isDisabled: false,
              isLoading: false),
        ),
        Visibility(
          visible: drinkList.isNotEmpty,
          child: PrimaryButton(
            onPressed: () {
              if (_title.text.isEmpty) {
                SnackBarService.instance
                    .showSnackBarInfo('Title field is mandatory');
                return;
              }

              AwesomeDialog(
                context: context,
                dialogType: DialogType.question,
                animType: AnimType.bottomSlide,
                title: 'Are you sure?',
                desc: 'You are updating item name to ${_title.text}',
                onDismissCallback: (type) {},
                autoDismiss: false,
                btnOkOnPress: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  if (!drinkList.contains(_title.text)) {
                    SnackBarService.instance.showSnackBarError('Invalid Title');
                    return;
                  }

                  _firestore
                      .updateItemName(
                          _auth.user!.uid, widget.upcCode, _title.text)
                      .then((value) {
                    _firestore.status = FirestoreStatus.ideal;
                    _auth.status = AuthStatus.notAuthenticated;
                    Navigator.pop(context);
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
            isDisabled: _firestore.status == FirestoreStatus.loading ||
                isImageUploading,
            isLoading: _firestore.status == FirestoreStatus.loading,
          ),
        ),
      ],
    );
  }
}
