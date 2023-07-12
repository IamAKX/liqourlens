import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/primary_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/gaps.dart';
import '../../widgets/input_password_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  static const String routePath = '/changePassword';

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        InputPasswordField(
          hint: 'Password',
          controller: _password,
          keyboardType: TextInputType.visiblePassword,
          icon: Icons.lock_person_outlined,
        ),
        verticalGap(defaultPadding * 2),
        PrimaryButton(
          onPressed: () {},
          label: 'Update',
          isDisabled: false,
          isLoading: false,
        )
      ],
    );
  }
}
