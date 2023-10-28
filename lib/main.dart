import 'dart:developer';

import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:alcohol_inventory/screens/blocked_user/blocked_user.dart';
import 'package:alcohol_inventory/screens/home/main_container.dart';
import 'package:alcohol_inventory/screens/onboarding/login_screen.dart';
import 'package:alcohol_inventory/services/auth_provider.dart';
import 'package:alcohol_inventory/services/firestore_service.dart';
import 'package:alcohol_inventory/services/report_provider.dart';
import 'package:alcohol_inventory/utils/router.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'services/api_provider.dart';

late SharedPreferences prefs;
UserProfile? user;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (AuthProvider().checkCurrentUserIsAuthenticated()) {
    user =
        await FirestoreProvider().getUserById(AuthProvider().user?.uid ?? '');
  }

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirestoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ApiProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportGeneratorProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LiquorLens',
        theme: globalTheme(context),
        home: getHomeScreen(),
        navigatorKey: navigatorKey,
        onGenerateRoute: NavRoute.generatedRoute,
      ),
    );
  }

  Widget getHomeScreen() {
    if (user == null) return const LoginScreen();
    if (user?.isActive ?? false) {
      FirestoreProvider().updateUserPartially(
          user?.id ?? '', {'lastLoggedIn': Timestamp.now()});
      return const HomeContainer();
    } else {
      return const BlockedUser();
    }
  }
}
