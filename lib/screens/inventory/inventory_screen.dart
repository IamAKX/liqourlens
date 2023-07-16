import 'package:alcohol_inventory/utils/theme.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/inventory_model.dart';
import '../../services/api_provider.dart';
import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import '../../utils/colors.dart';
import '../../widgets/gaps.dart';
import 'inventory_item_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key, required this.switchTabs});
  final Function(int) switchTabs;
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  late ApiProvider _api;
  List<InventoryModel> list = [];
  List<InventoryModel> backUpList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _firestore.status = FirestoreStatus.ideal;
        _api.status = ApiStatus.ideal;
        _auth.status = AuthStatus.notAuthenticated;
        loadScreen();
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
      appBar: AppBarWithSearchSwitch(
        keepAppBarColors: false,
        backgroundColor: Colors.white,
        animation: (child) => AppBarAnimationSlideLeft(
            milliseconds: 300, withFade: false, percents: 1.0, child: child),
        onChanged: (value) {
          setState(() {
            list.clear();
            if (value.isEmpty) {
              list.addAll(backUpList);
            } else {
              list.addAll(
                backUpList
                    .where((element) =>
                        element.item?.title
                            ?.toLowerCase()
                            .contains(value.toLowerCase()) ??
                        false)
                    .toList(),
              );
            }
          });
        },
        appBarBuilder: (context) => AppBar(
          title: const Text(
            'Inventory',
          ),
          actions: const [
            AppBarSearchButton(
              buttonHasTwoStates: false,
            )
          ],
        ),
      ),
      body: _api.status == ApiStatus.loading ||
              _firestore.status == FirestoreStatus.loading
          ? showLoader(context)
          : list.isEmpty
              ? showEmptyList(context)
              : getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: list.length,
      itemBuilder: (context, index) =>
          InventoryItemCard(inventory: list.elementAt(index)),
    );
  }

  void loadScreen() async {
    setState(() {
      _firestore.getAllItemsInInventory(_auth.user?.uid ?? '').then((value) {
        list = value;
        backUpList.addAll(list);
      });
    });
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

  showEmptyList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/notfound.svg',
            width: 100,
          ),
          verticalGap(defaultPadding),
          Text(
            'No item found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }
}
