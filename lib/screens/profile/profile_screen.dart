import 'package:alcohol_inventory/screens/onboarding/login_screen.dart';
import 'package:alcohol_inventory/screens/profile/about_us.dart';
import 'package:alcohol_inventory/screens/profile/chnage_password_screen.dart';
import 'package:alcohol_inventory/screens/profile/edit_profile_screen.dart';
import 'package:alcohol_inventory/screens/profile/profile_menu_item_model.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';

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
      name: 'Report',
      path: '',
      icon: Icons.description_outlined,
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
                    onTap: () {
                      if (index == menuItems.length - 1) {
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
                    borderRadius:
                        BorderRadius.circular(settingsPageUserIconSize),
                    child: Image.asset(
                      'assets/images/dummy_user.jpg',
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
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
