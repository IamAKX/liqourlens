import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/primary_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/gaps.dart';
import '../../widgets/input_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  static const String routePath = '/editProfile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _businessAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        InputField(
          hint: 'Full Name',
          controller: _name,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.person_outline,
        ),
        verticalGap(defaultPadding),
        InputField(
          hint: 'Phone',
          controller: _phone,
          keyboardType: TextInputType.phone,
          obscure: false,
          icon: Icons.phone_outlined,
        ),
        verticalGap(defaultPadding),
        InputField(
          hint: 'Business Name',
          controller: _businessName,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.storefront_outlined,
        ),
        verticalGap(defaultPadding),
        InputField(
          hint: 'Business Address',
          controller: _businessAddress,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: Icons.location_pin,
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
