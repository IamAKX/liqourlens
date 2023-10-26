import 'package:alcohol_inventory/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';

class InventoryItemView extends StatefulWidget {
  const InventoryItemView({super.key});
  static const String routePath = '/inventoryItemView';

  @override
  State<InventoryItemView> createState() => _InventoryItemViewState();
}

class _InventoryItemViewState extends State<InventoryItemView> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;

  List<String>? drinkList = [];

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

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Repository',
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_firestore.status == FirestoreStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(drinkList?.elementAt(index) ?? ''),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: dividerColor,
          );
        },
        itemCount: drinkList?.length ?? -1);
  }

  void loadScreen() {
    _firestore.getInventoryItem(_auth.user?.uid ?? '').then((value) {
      setState(() {
        drinkList = value;
      });
    });
  }
}
