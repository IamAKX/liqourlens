import 'package:alcohol_inventory/screens/home/main_container.dart';
import 'package:alcohol_inventory/screens/onboarding/login_screen.dart';
import 'package:alcohol_inventory/services/auth_provider.dart';
import 'package:alcohol_inventory/services/firestore_service.dart';
import 'package:alcohol_inventory/utils/router.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    if (AuthProvider().checkCurrentUserIsAuthenticated()) {
      return const HomeContainer();
    }
    return const LoginScreen();
  }
}
