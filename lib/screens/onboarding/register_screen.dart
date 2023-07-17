import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:alcohol_inventory/screens/onboarding/login_screen.dart';
import 'package:alcohol_inventory/screens/onboarding/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../services/auth_provider.dart';
import '../../services/snackbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/primary_button.dart';
import 'business_detail.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routePath = '/register';
  static bool isAgree = false;
  static String image = '';
  static bool isImageUploading = false;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _businessNameCtrl = TextEditingController();
  final TextEditingController _businessAddressCtrl = TextEditingController();

  int step = 1;
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding * 1.5,
        vertical: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalGap(defaultPadding * 1.5),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back,
              color: primaryColor,
            ),
          ),
          verticalGap(defaultPadding),
          Row(
            children: [
              Text(
                'New\nAccount 🙋🏼‍♂️',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$step',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '/2',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: primaryColor,
                                ),
                      ),
                    ],
                  ),
                  Text(
                    'STEPS',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          verticalGap(defaultPadding * 1.5),
          Expanded(child: getWidgetByStep(step)),
          verticalGap(defaultPadding * 1.5),
          Row(
            children: [
              Visibility(
                visible: step > 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      step--;
                    });
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                visible: step < 2,
                child: InkWell(
                  onTap: () {
                    if (_nameCtrl.text.isEmpty) {
                      SnackBarService.instance
                          .showSnackBarError('Enter Full name');
                      return;
                    }
                    if (_emailCtrl.text.isEmpty || !isEmail(_emailCtrl.text)) {
                      SnackBarService.instance
                          .showSnackBarError('Enter valid email');
                      return;
                    }
                    if (_passwordCtrl.text.trim().isEmpty ||
                        _passwordCtrl.text.trim().length < 8) {
                      SnackBarService.instance.showSnackBarError(
                          'Password must be 8 character long');
                      return;
                    }

                    if (_phoneCtrl.text.isEmpty) {
                      SnackBarService.instance
                          .showSnackBarError('Enter valid phone');
                      return;
                    }
                    if (!RegisterScreen.isAgree) {
                      SnackBarService.instance.showSnackBarError(
                          'Please check the agreement before proceeding');
                      return;
                    }
                    setState(() {
                      step++;
                    });
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: step == 2,
                child: SizedBox(
                  width: 250,
                  child: PrimaryButton(
                    onPressed: () {
                      if (_businessNameCtrl.text.isEmpty) {
                        SnackBarService.instance
                            .showSnackBarError('Enter business name');
                        return;
                      }
                      if (_businessAddressCtrl.text.isEmpty) {
                        SnackBarService.instance
                            .showSnackBarError('Enter business address');
                        return;
                      }

                      UserProfile newUser = UserProfile(
                        name: _nameCtrl.text,
                        email: _emailCtrl.text,
                        phone: _phoneCtrl.text,
                        businessName: _businessNameCtrl.text,
                        businessAddress: _businessAddressCtrl.text,
                        image: RegisterScreen.image,
                      );
                      _auth
                          .registerUserWithEmailAndPassword(
                              newUser, _passwordCtrl.text)
                          .then((value) {
                        if (value) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.routePath, (route) => false);
                        }
                      });
                    },
                    label: 'Register',
                    isDisabled: _auth.status == AuthStatus.authenticating,
                    isLoading: _auth.status == AuthStatus.authenticating,
                  ),
                ),
              ),
            ],
          ),
          verticalGap(defaultPadding),
        ],
      ),
    );
  }

  getWidgetByStep(int step) {
    switch (step) {
      case 1:
        return UserDetail(
          emailCtrl: _emailCtrl,
          passwordCtrl: _passwordCtrl,
          phoneCtrl: _phoneCtrl,
          nameCtrl: _nameCtrl,
        );
      case 2:
        return BusinessDetails(
          businessNameCtrl: _businessNameCtrl,
          businessAddressCtrl: _businessAddressCtrl,
          emailCtrl: _emailCtrl,
        );

      default:
        return Container();
    }
  }
}
