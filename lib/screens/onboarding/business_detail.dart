import 'package:alcohol_inventory/widgets/input_field.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({
    super.key,
    required this.businessNameCtrl,
    required this.businessAddressCtrl,
  });
  final TextEditingController businessNameCtrl;
  final TextEditingController businessAddressCtrl;

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        profileImageWidget(),
        verticalGap(defaultPadding * 1.5),
        InputField(
          hint: 'Business Name',
          controller: widget.businessNameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.storefront_outlined,
        ),
        verticalGap(defaultPadding * 1.5),
        InputField(
          hint: 'Business Address',
          controller: widget.businessAddressCtrl,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: Icons.location_pin,
        ),
        verticalGap(defaultPadding * 1.5),
      ],
    );
  }

  profileImageWidget() {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(settingsPageUserIconSize),
              child: Image.asset(
                'assets/logo/profile_image_placeholder.png',
                height: 110,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 1,
              right: 1,
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalGap(defaultPadding),
        const Text('Choose profile picture'),
      ],
    );
  }
}
