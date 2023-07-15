import 'package:alcohol_inventory/screens/onboarding/register_screen.dart';
import 'package:alcohol_inventory/widgets/input_field.dart';
import 'package:alcohol_inventory/widgets/input_password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import 'agreement_screen.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.phoneCtrl,
    required this.nameCtrl,
  });
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController nameCtrl;
  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InputField(
          hint: 'Full Name',
          controller: widget.nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.person_outline,
        ),
        verticalGap(defaultPadding * 1.5),
        InputField(
          hint: 'Email',
          controller: widget.emailCtrl,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          icon: Icons.email_outlined,
        ),
        verticalGap(defaultPadding * 1.5),
        InputPasswordField(
            hint: 'Password',
            controller: widget.passwordCtrl,
            keyboardType: TextInputType.visiblePassword,
            icon: Icons.lock_person_outlined),
        verticalGap(defaultPadding * 1.5),
        InputField(
          hint: 'Phone',
          controller: widget.phoneCtrl,
          keyboardType: TextInputType.phone,
          obscure: false,
          icon: Icons.phone_outlined,
        ),
        verticalGap(defaultPadding * 1.5),
        Row(
          children: [
            Checkbox(
              // activeColor: Colors.white,
              // checkColor: primaryColor,
              value: RegisterScreen.isAgree,
              onChanged: (value) {
                setState(() {
                  RegisterScreen.isAgree = !RegisterScreen.isAgree;
                });
              },
            ),
            horizontalGap(8),
            Flexible(
              child: RichText(
                text: TextSpan(
                  text: 'I agree to the ',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: textColorDark,
                      ),
                  children: [
                    TextSpan(
                        text: 'terms and conditions',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, AgreementScreen.routePath);
                          }),
                    const TextSpan(text: ' as set out by the user agreement.'),
                  ],
                ),
                softWrap: true,
              ),
            )
          ],
        )
      ],
    );
  }
}
