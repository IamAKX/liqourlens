import 'dart:developer';
import 'dart:io';

import 'package:alcohol_inventory/screens/onboarding/login_screen.dart';
import 'package:alcohol_inventory/screens/profile/about_us.dart';
import 'package:alcohol_inventory/screens/profile/chnage_password_screen.dart';
import 'package:alcohol_inventory/screens/profile/edit_profile_screen.dart';
import 'package:alcohol_inventory/screens/profile/profile_menu_item_model.dart';
import 'package:alcohol_inventory/screens/profile/upload_report.dart';
import 'package:alcohol_inventory/services/report_provider.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import '../../services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routePath = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  UserProfile? userProfile;
  bool isImageUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  void loadScreen() async {
    await _firestore.getUserById(_auth.user?.uid ?? '').then((value) {
      setState(() {
        userProfile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);
    log(_auth.user?.photoURL ?? '-no url');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: getBody(context),
    );
  }

  List<ProfileMenuItemModel> menuItems = [
    ProfileMenuItemModel(
      name: 'Profile details',
      path: EditProfile.routePath,
      icon: Icons.person_outline,
    ),
    ProfileMenuItemModel(
      name: 'Change password',
      path: ChangePassword.routePath,
      icon: Icons.lock_person_outlined,
    ),
    ProfileMenuItemModel(
      name: 'Clear Inventory',
      path: '',
      icon: Icons.delete_forever_outlined,
    ),
    ProfileMenuItemModel(
      name: 'Report',
      path: '',
      icon: Icons.description_outlined,
    ),
    ProfileMenuItemModel(
      name: 'Report New',
      path: '',
      icon: Icons.description_outlined,
    ),
    ProfileMenuItemModel(
      name: 'Upload Report Template',
      path: UploadReport.routePath,
      icon: Icons.upload_file,
    ),
    ProfileMenuItemModel(
      name: 'About us',
      path: AboutUsScreen.routePath,
      icon: Icons.info_outline,
    ),
    ProfileMenuItemModel(
      name: 'Logout',
      path: LoginScreen.routePath,
      icon: Icons.logout_outlined,
    )
  ];

  getBody(BuildContext context) {
    return Column(
      children: [
        editProfilePicture(),
        verticalGap(defaultPadding),
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                    onTap: () async {
                      if (index == 7) {
                        _auth
                            .logoutUser()
                            .then((value) => Navigator.pushNamedAndRemoveUntil(
                                context,
                                menuItems.elementAt(index).path,
                                (route) => false))
                            .then((value) {
                          setState(() {
                            loadScreen();
                          });
                        });
                      } else if (index == 2) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.bottomSlide,
                          title: 'Are you sure?',
                          desc:
                              'You are about to delete your inventory data which cannot to restored',
                          onDismissCallback: (type) {},
                          autoDismiss: false,
                          btnCancelColor: primaryColor,
                          btnOkOnPress: () {
                            _firestore
                                .clearInventory(userProfile?.id ?? '')
                                .then((value) {
                              SnackBarService.instance
                                  .showSnackBarSuccess('Inventory cleared');
                              setState(() {});
                            });
                            Navigator.of(context).pop();
                          },
                          btnOkColor: Colors.red,
                          btnOkText: 'Delete',
                          btnCancelOnPress: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).pop();
                          },
                        ).show();
                      } else if (index == 3) {
                        if (await Permission.storage.request().isGranted &&
                            await Permission.manageExternalStorage
                                .request()
                                .isGranted) {
                          ReportGeneratorProvider.instance
                              .generateInventoryReport(_auth.user?.uid ?? '');
                        } else {
                          SnackBarService.instance.showSnackBarError(
                              'Grant storage access to generate and save report');
                        }
                      } else if (index == 4) {
                        if (await Permission.storage.request().isGranted &&
                            await Permission.manageExternalStorage
                                .request()
                                .isGranted) {
                          ReportGeneratorProvider.instance
                              .generateInventoryReportV2(_auth.user?.uid ?? '');
                        } else {
                          SnackBarService.instance.showSnackBarError(
                              'Grant storage access to generate and save report');
                        }
                      } else {
                        Navigator.pushNamed(
                                context, menuItems.elementAt(index).path)
                            .then((value) {
                          loadScreen();
                        });
                      }
                    },
                    leading: Icon(
                      menuItems.elementAt(index).icon,
                      color: index == menuItems.length - 1
                          ? Colors.red
                          : primaryColor,
                    ),
                    title: Text(
                      menuItems.elementAt(index).name,
                      style: TextStyle(
                        color: index == menuItems.length - 1
                            ? Colors.red
                            : primaryColor,
                      ),
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(
                    color: dividerColor,
                  ),
              itemCount: menuItems.length),
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

  Container editProfilePicture() {
    return Container(
      width: double.infinity,
      color: primaryColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              children: [
                Hero(
                  tag: 'image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: (userProfile?.image?.isEmpty ?? true)
                        ? Image.asset(
                            'assets/logo/profile_image_placeholder.png',
                            width: 110,
                            height: 110,
                          )
                        : CachedNetworkImage(
                            imageUrl: userProfile?.image ?? '',
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
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: InkWell(
                    onTap: isImageUploading
                        ? null
                        : () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              File imageFile = File(image.path);
                              setState(() {
                                isImageUploading = true;
                              });
                              StorageService.uploadProfileImage(
                                      imageFile,
                                      '${_auth.user?.email}.${image.name.split('.')[1]}',
                                      'profileImage')
                                  .then((value) async {
                                _firestore.updateUserPartially(
                                    _auth.user?.uid ?? '',
                                    {'image': value}).then((value) {
                                  isImageUploading = false;
                                  loadScreen();
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
                      child: isImageUploading
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
          verticalGap(defaultPadding / 2),
          Text(
            'Hello ${userProfile?.name ?? ''}👋🏻',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
