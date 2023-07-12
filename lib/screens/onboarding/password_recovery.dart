import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/widgets/primary_button.dart';
import 'package:flutter/material.dart';

import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/input_field.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});
  static const String routePath = '/recoverPassword';

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController _emailCtrl = TextEditingController();

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
          Text(
            'Password\nForgotten 🙆🏼‍♂️',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          verticalGap(defaultPadding * 1.5),
          const Text(
              'Enter your registed email address. We will send a password reset link'),
          verticalGap(defaultPadding * 1.5),
          InputField(
            hint: 'Email',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            obscure: false,
            icon: Icons.email_outlined,
          ),
          verticalGap(defaultPadding * 1.5),
          PrimaryButton(
            onPressed: () {},
            label: 'Reset Password',
            isDisabled: false,
            isLoading: false,
          )
        ],
      ),
    );
  }
}
