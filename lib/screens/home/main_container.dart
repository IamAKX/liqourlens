import 'package:alcohol_inventory/screens/barcode_scanner/scanner_screen.dart';
import 'package:alcohol_inventory/screens/dashboard/dashboard_screen.dart';
import 'package:alcohol_inventory/screens/inventory/inventory_screen.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});
  static const String routePath = '/homeContainer';

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int _selectedIndex = 0;

  switchTabs(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => switchTabs(index),
        items: [
          FlashyTabBarItem(
            icon: const Icon(
              Icons.category_outlined,
            ),
            title: const Text('Dashboard'),
          ),
          FlashyTabBarItem(
            icon: Image.asset(
              'assets/images/barcode_scanner.png',
              width: 20,
              color: const Color(0xff9496c1),
            ),
            title: const Text('Scanner'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.inventory_outlined),
            title: const Text('Inventory'),
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen(switchTabs: switchTabs);
      case 1:
        return ScannerScreen(switchTabs: switchTabs);
      case 2:
        return InventoryScreen(switchTabs: switchTabs);
      default:
        return Container();
    }
  }
}
