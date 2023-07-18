import 'dart:io';

import 'package:alcohol_inventory/models/upc_item_model.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/enum.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/inventory_model.dart';
import '../../models/upc_response_model.dart';
import '../../models/user_profile.dart';
import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import '../../services/storage_service.dart';
import '../../utils/theme.dart';
import '../../widgets/input_field.dart';
import '../../widgets/primary_button.dart';

class CustomInventoryScreen extends StatefulWidget {
  const CustomInventoryScreen({super.key, required this.upc});
  static const String routePath = '/customInventoryScreen';
  final String upc;

  @override
  State<CustomInventoryScreen> createState() => _CustomInventoryScreenState();
}

class _CustomInventoryScreenState extends State<CustomInventoryScreen> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  UserProfile? userProfile;
  bool isImageUploading = false;

  final TextEditingController _upc = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  String liquorImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _upc.text = widget.upc;
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _firestore = Provider.of<FirestoreProvider>(context);
    _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Product',
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
          controller: _upc,
          keyboardType: TextInputType.name,
          obscure: false,
          enabled: false,
          icon: Icons.liquor_outlined,
        ),
        verticalGap(defaultPadding),
        InputField(
          hint: 'Title',
          controller: _title,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.liquor_outlined,
        ),
        verticalGap(defaultPadding),
        InputField(
          hint: 'Quantity',
          controller: _quantity,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          obscure: false,
          icon: Icons.liquor_outlined,
        ),
        verticalGap(defaultPadding),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 100,
            height: 140,
            child: InkWell(
              onTap: isImageUploading
                  ? null
                  : () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        File imageFile = File(image.path);
                        setState(() {
                          isImageUploading = true;
                        });
                        StorageService.uploadProfileImage(
                                imageFile,
                                '${_auth.user?.uid}_${widget.upc}.${image.name.split('.')[1]}',
                                'liquor')
                            .then((value) async {
                          setState(() {});
                          liquorImage = value;
                          isImageUploading = false;
                        });
                      }
                    },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(defaultPadding),
                child: CachedNetworkImage(
                  imageUrl: liquorImage,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 140,
                  placeholder: (context, url) => Image.asset(
                    'assets/logo/loading.gif',
                    width: 100,
                    height: 140,
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: dividerColor),
                      borderRadius: BorderRadius.circular(defaultPadding),
                    ),
                    child: const Text('Select Image'),
                  ),
                ),
              ),
            ),
          ),
        ),
        verticalGap(defaultPadding),
        PrimaryButton(
          onPressed: () {
            if (_title.text.isEmpty ||
                _quantity.text.isEmpty ||
                liquorImage.isEmpty) {
              SnackBarService.instance
                  .showSnackBarInfo('All fields are mandatory');
              return;
            }
            double qty = double.parse(_quantity.text);
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
                UpcItemModel upcItem = UpcItemModel(
                  upc: widget.upc,
                  title: _title.text,
                  description: _description.text,
                  brand: _brand.text,
                  images: [liquorImage],
                );
                InventoryModel? inventoryItem = InventoryModel(
                    item: upcItem,
                    quanty: qty,
                    updateValue: qty,
                    lastUpdateTime: Timestamp.now(),
                    updateType: ModificationType.stocked.name);

                _firestore
                    .updateInventory(_auth.user!.uid, inventoryItem.item!.upc!,
                        inventoryItem)
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
          isDisabled:
              _firestore.status == FirestoreStatus.loading || isImageUploading,
          isLoading: _firestore.status == FirestoreStatus.loading,
        ),
      ],
    );
  }
}
