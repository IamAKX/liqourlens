import 'dart:developer';
import 'dart:io';

import 'package:alcohol_inventory/screens/onboarding/register_screen.dart';
import 'package:alcohol_inventory/widgets/input_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/storage_service.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({
    super.key,
    required this.businessNameCtrl,
    required this.businessAddressCtrl,
    required this.emailCtrl,
  });
  final TextEditingController businessNameCtrl;
  final TextEditingController businessAddressCtrl;
  final TextEditingController emailCtrl;

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RegisterScreen.isImageUploading = false;
  }

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
            SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: CachedNetworkImage(
                      imageUrl: RegisterScreen.image,
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/logo/profile_image_placeholder.png',
                        width: 110,
                        height: 110,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: InkWell(
                      onTap: RegisterScreen.isImageUploading
                          ? null
                          : () async {
                              log('open');
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                File imageFile = File(image.path);
                                setState(() {
                                  RegisterScreen.isImageUploading = true;
                                });
                                StorageService.uploadProfileImage(
                                        imageFile,
                                        '${widget.emailCtrl.text}.${image.name.split('.')[1]}',
                                        'profileImage')
                                    .then((value) async {
                                  setState(() {
                                    RegisterScreen.image = value;
                                    RegisterScreen.isImageUploading = false;
                                  });
                                });
                              }
                            },
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
                        child: RegisterScreen.isImageUploading
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                      ),
                    ),
                  ),
                ],
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
