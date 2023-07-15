import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:alcohol_inventory/services/firestore_service.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../services/snackbar_service.dart';
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
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _firestore = Provider.of<FirestoreProvider>(context);
    _auth = Provider.of<AuthProvider>(context);

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
          onPressed: () async {
            if (_name.text.isEmpty ||
                _phone.text.isEmpty ||
                _businessName.text.isEmpty ||
                _businessAddress.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
              return;
            }
            userProfile?.name = _name.text;
            userProfile?.phone = _phone.text;
            userProfile?.businessAddress = _businessAddress.text;
            userProfile?.businessName = _businessName.text;
            await _firestore.updateUser(userProfile!).then((value) {
              if (value) Navigator.pop(context);
            });
          },
          label: 'Update',
          isDisabled: _auth.status == AuthStatus.authenticating ||
              _firestore.status == FirestoreStatus.loading,
          isLoading: _auth.status == AuthStatus.authenticating ||
              _firestore.status == FirestoreStatus.loading,
        )
      ],
    );
  }

  void loadScreen() async {
    await _firestore.getUserById(_auth.user?.uid ?? '').then((value) {
      setState(() {
        userProfile = value;
        _businessAddress.text = userProfile?.businessAddress ?? '';
        _businessName.text = userProfile?.businessName ?? '';
        _name.text = userProfile?.name ?? '';
        _phone.text = userProfile?.phone ?? '';
      });
    });
  }
}
