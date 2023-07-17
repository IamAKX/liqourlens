import 'package:alcohol_inventory/models/history_model.dart';
import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:alcohol_inventory/screens/dashboard/search_box.dart';
import 'package:alcohol_inventory/screens/inventory/history_screen.dart';
import 'package:alcohol_inventory/screens/inventory/removed_history_screen.dart';
import 'package:alcohol_inventory/screens/profile/profile_screen.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/date_time_formatter.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import 'header_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.switchTabs});
  final Function(int) switchTabs;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  UserProfile? userProfile;
  List<HistoryModel> recentRemovedList = [];
  List<HistoryModel> recentActivityList = [];

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
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        title: Text('Hello ${userProfile?.name ?? ''}👋🏻'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.routePath)
                  .then((value) {
                loadScreen();
              });
            },
            icon: Hero(
              tag: 'image',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: CachedNetworkImage(
                  imageUrl: userProfile?.image ?? '',
                  fit: BoxFit.cover,
                  width: 35,
                  height: 35,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/logo/profile_image_placeholder.png',
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        getHeader(),
        Expanded(
          child: ListView(
            children: [
              verticalGap(defaultPadding),
              if (recentRemovedList.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RECENTLY REMOVED ITEMS',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: hintColor,
                                ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RemovedHistory.routePath);
                        },
                        child: Text(
                          'View All',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      )
                    ],
                  ),
                ),
              if (recentRemovedList.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Card(
                        elevation: defaultPadding / 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: defaultPadding,
                            horizontal: defaultPadding / 2),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateTimeFormatter.formatDate(recentRemovedList
                                    .elementAt(index)
                                    .lastUpdateTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${recentRemovedList.elementAt(index).name}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: textColorDark,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  horizontalGap(defaultPadding),
                                  Text(
                                    '${recentRemovedList.elementAt(index).updateValue}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: recentRemovedList.length,
                  ),
                ),
              verticalGap(defaultPadding),
              if (recentActivityList.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RECENT ACTIVITY',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: hintColor,
                                ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, HistoryScreen.routePath);
                        },
                        child: Text(
                          'View All',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              verticalGap(defaultPadding / 2),
              if (recentActivityList.isNotEmpty)
                for (HistoryModel model in recentActivityList) ...{
                  Card(
                    elevation: defaultPadding / 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                      vertical: defaultPadding / 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              defaultPadding,
                              defaultPadding,
                              defaultPadding,
                              defaultPadding / 2),
                          child: Text(
                            model.upc ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              defaultPadding, 0, defaultPadding, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  model.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: textColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              horizontalGap(defaultPadding),
                              Text(
                                '${model.updateValue}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: textColorDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            defaultPadding,
                            0,
                            defaultPadding,
                            defaultPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateTimeFormatter.formatDate(
                                    model.lastUpdateTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: textColorLight,
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: getColorByType(model.updateType ?? '')
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  model.updateType?.toUpperCase() ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: getColorByType(
                                            model.updateType ?? ''),
                                      ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                }
            ],
          ),
        ),
      ],
    );
  }

  SizedBox getHeader() {
    return SizedBox(
      height: 230,
      child: Stack(
        children: [
          Container(
            height: 180,
            color: primaryColor,
          ),
          HeaderCard(
            totalUnits: userProfile?.totalUnit ?? 0,
            lastRestocked: userProfile?.lastRestocked ?? 0,
            lastRestockedItemName: userProfile?.lastRestockedItemName ?? '',
          ),
          SearchBox(searchCtrl: _searchCtrl)
        ],
      ),
    );
  }

  void loadScreen() async {
    _firestore.getUserById(_auth.user?.uid ?? '').then((value) {
      setState(() {
        userProfile = value;
      });
    });

    _firestore
        .getLimitedDeleteHistoryByUser(_auth.user?.uid ?? '', 5)
        .then((value) {
      setState(() {
        recentRemovedList = value;
      });
    });

    _firestore.getLimitedHistoryByUser(_auth.user?.uid ?? '', 5).then((value) {
      setState(() {
        recentActivityList = value;
      });
    });
  }
}
