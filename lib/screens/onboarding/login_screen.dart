// ignore_for_file: use_build_context_synchronously

import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:alcohol_inventory/screens/blocked_user/blocked_user.dart';
import 'package:alcohol_inventory/screens/onboarding/password_recovery.dart';
import 'package:alcohol_inventory/screens/onboarding/register_screen.dart';
import 'package:alcohol_inventory/services/firestore_service.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/widgets/input_field.dart';
import 'package:alcohol_inventory/widgets/input_password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../services/snackbar_service.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/primary_button.dart';
import '../home/main_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routePath = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  late AuthProvider _auth;
  late FirestoreProvider _firestore;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);
    return Scaffold(
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding,
            ),
            children: [
              verticalGap(defaultPadding * 1.5),
              Text(
                'Welcome\nBack 👋🏻',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              verticalGap(defaultPadding * 1.5),
              InputField(
                hint: 'Email',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                obscure: false,
                icon: Icons.email_outlined,
              ),
              verticalGap(defaultPadding * 1.5),
              InputPasswordField(
                hint: 'Password',
                controller: _passwordCtrl,
                keyboardType: TextInputType.visiblePassword,
                icon: Icons.lock_person_outlined,
              ),
              verticalGap(defaultPadding * 2),
              PrimaryButton(
                onPressed: () async {
                  _auth
                      .loginUserWithEmailAndPassword(
                          _emailCtrl.text, _passwordCtrl.text)
                      .then((value) async {
                    if (_auth.status == AuthStatus.authenticated) {
                      UserProfile? user =
                          await _firestore.getUserById(_auth.user?.uid ?? '');
                      if (user?.isActive ?? false) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeContainer.routePath,
                          (route) => false,
                        );
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          BlockedUser.routePath,
                          (route) => false,
                        );
                      }
                    }
                  });
                },
                label: 'Login',
                isDisabled: _auth.status == AuthStatus.authenticating,
                isLoading: _auth.status == AuthStatus.authenticating,
              ),
              verticalGap(defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.routePath);
                    },
                    child: Text(
                      'Register',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: primaryColor,
                          ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    color: Colors.grey,
                    width: 2,
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RecoverPassword.routePath);
                    },
                    child: Text(
                      'Password',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: primaryColor,
                          ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            '© ${DateTime.now().year} LiquorLens',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                ),
          ),
        ),
      ],
    );
  }
}
