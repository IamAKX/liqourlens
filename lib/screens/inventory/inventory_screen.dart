import 'package:alcohol_inventory/utils/theme.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';

import 'inventory_item_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key, required this.switchTabs});
  final Function(int) switchTabs;
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearchSwitch(
        keepAppBarColors: false,
        backgroundColor: Colors.white,
        animation: (child) => AppBarAnimationSlideLeft(
            milliseconds: 600, withFade: false, percents: 1.0, child: child),
        onChanged: (value) {},
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
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: 35,
      itemBuilder: (context, index) => const InventoryItemCard(),
    );
  }
}
