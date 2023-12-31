import 'package:alcohol_inventory/screens/blocked_user/blocked_user.dart';
import 'package:alcohol_inventory/screens/home/main_container.dart';
import 'package:alcohol_inventory/screens/inventory/custom_inventory.dart';
import 'package:alcohol_inventory/screens/inventory/history_screen.dart';
import 'package:alcohol_inventory/screens/inventory/manual_inventory.dart';
import 'package:alcohol_inventory/screens/inventory/product_history_screen.dart';
import 'package:alcohol_inventory/screens/inventory/removed_history_screen.dart';
import 'package:alcohol_inventory/screens/inventory/update_inventory.dart';
import 'package:alcohol_inventory/screens/inventory/update_item_name.dart';
import 'package:alcohol_inventory/screens/onboarding/agreement_screen.dart';
import 'package:alcohol_inventory/screens/onboarding/password_recovery.dart';
import 'package:alcohol_inventory/screens/onboarding/register_screen.dart';
import 'package:alcohol_inventory/screens/profile/about_us.dart';
import 'package:alcohol_inventory/screens/profile/chnage_password_screen.dart';
import 'package:alcohol_inventory/screens/profile/edit_profile_screen.dart';
import 'package:alcohol_inventory/screens/profile/inventory_items_view.dart';
import 'package:alcohol_inventory/screens/profile/profile_screen.dart';
import 'package:alcohol_inventory/screens/profile/upload_report.dart';
import 'package:flutter/material.dart';

import '../screens/onboarding/login_screen.dart';

class NavRoute {
  static MaterialPageRoute<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routePath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RegisterScreen.routePath:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RecoverPassword.routePath:
        return MaterialPageRoute(builder: (_) => const RecoverPassword());
      case AgreementScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AgreementScreen());
      case HomeContainer.routePath:
        return MaterialPageRoute(builder: (_) => const HomeContainer());
      case HistoryScreen.routePath:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case UpdateItemNameScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => UpdateItemNameScreen(
                  upcCode: settings.arguments as String,
                ));
      case UpdateInventoryScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => UpdateInventoryScreen(
                  barcode: settings.arguments as String,
                ));
      case ProductHistory.routePath:
        return MaterialPageRoute(
            builder: (_) => ProductHistory(
                  upc: settings.arguments as String,
                ));
      case RemovedHistory.routePath:
        return MaterialPageRoute(builder: (_) => const RemovedHistory());
      case ProfileScreen.routePath:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case EditProfile.routePath:
        return MaterialPageRoute(builder: (_) => const EditProfile());
      case ChangePassword.routePath:
        return MaterialPageRoute(builder: (_) => const ChangePassword());
      case AboutUsScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());
      case UploadReport.routePath:
        return MaterialPageRoute(builder: (_) => const UploadReport());
      case BlockedUser.routePath:
        return MaterialPageRoute(builder: (_) => const BlockedUser());
      case ManualInventoryScreen.routePath:
        return MaterialPageRoute(builder: (_) => const ManualInventoryScreen());
      case InventoryItemView.routePath:
        return MaterialPageRoute(builder: (_) => const InventoryItemView());
      case CustomInventoryScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => CustomInventoryScreen(
            upc: settings.arguments as String,
          ),
        );

      default:
        return errorRoute();
    }
  }
}

errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return const Scaffold(
      body: Center(
        child: Text('Undefined route'),
      ),
    );
  });
}
