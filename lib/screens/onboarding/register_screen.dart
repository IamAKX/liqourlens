import 'package:alcohol_inventory/screens/onboarding/user_detail.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/primary_button.dart';
import 'business_detail.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routePath = '/register';
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

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {},
                      label: 'Register',
                      isDisabled: false,
                      isLoading: false),
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
            nameCtrl: _nameCtrl);
      case 2:
        return BusinessDetails(
          businessNameCtrl: _businessNameCtrl,
          businessAddressCtrl: _businessAddressCtrl,
        );

      default:
        return Container();
    }
  }
}
