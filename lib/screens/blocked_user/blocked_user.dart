import 'dart:developer';

import 'package:alcohol_inventory/screens/onboarding/login_screen.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_provider.dart';
import '../../services/snackbar_service.dart';
import '../../utils/colors.dart';

class BlockedUser extends StatefulWidget {
  const BlockedUser({super.key});
  static const String routePath = '/blockedUser';

  @override
  State<BlockedUser> createState() => _BlockedUserState();
}

class _BlockedUserState extends State<BlockedUser> {
  late AuthProvider _auth;
  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/blocked.svg',
            width: 150,
            height: 150,
          ),
          verticalGap(defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              'Your account is temporarily suspended',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor.withOpacity(0.5),
                  ),
            ),
          ),
          verticalGap(defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              horizontalGap(defaultPadding * 2),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    String email =
                        Uri.encodeComponent("inventorytrack007@gmail.com");
                    String subject =
                        Uri.encodeComponent("Request to unblock my account");
                    String body =
                        'Hi Admin,Below are my detail:<br>Name: ${_auth.user?.displayName}<br>Email: ${_auth.user?.email}<br>UID: ${_auth.user?.uid}<br><br>Please unblock my account.<br><br>Thanks and Regards!';
                    log(body);
                    Uri mail =
                        Uri.parse("mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      SnackBarService.instance.showSnackBarInfo(
                          'Send email at inventorytrack007@gmail.com');
                    }
                  },
                  child: const Text('Contact admin'),
                ),
              ),
              horizontalGap(defaultPadding * 2),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    _auth.logoutUser().then((value) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routePath, (route) => false);
                    });
                  },
                  child: const Text('Log out'),
                ),
              ),
              horizontalGap(defaultPadding * 2),
            ],
          ),
          verticalGap(defaultPadding),
          TextButton(
            onPressed: () async {
              await launchUrl(Uri.parse('https://www.liquorlens.com/'));
            },
            child: const Text('Subscribe to www.liquorlens.com'),
          ),
        ],
      ),
    );
  }
}
