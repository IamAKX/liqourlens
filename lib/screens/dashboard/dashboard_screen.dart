import 'package:alcohol_inventory/dummy/dummy_item.dart';
import 'package:alcohol_inventory/models/unit_model.dart';
import 'package:alcohol_inventory/screens/dashboard/search_box.dart';
import 'package:alcohol_inventory/screens/inventory/history_screen.dart';
import 'package:alcohol_inventory/screens/inventory/removed_history_screen.dart';
import 'package:alcohol_inventory/screens/profile/profile_screen.dart';
import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';

import 'package:flutter/material.dart';

import 'header_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.switchTabs});
  final Function(int) switchTabs;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        title: const Text('Hello Marcell👋🏻'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.routePath);
            },
            icon: Hero(
              tag: 'image',
              child: ClipOval(
                child: Image.asset(
                  'assets/images/dummy_user.jpg',
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LAST 5 REMOVED',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: hintColor,
                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RemovedHistory.routePath);
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
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
                              dummyList.elementAt(index).date ?? '',
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
                                    dummyList.elementAt(index).name ?? '',
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
                                  dummyList.elementAt(index).quantity ?? '',
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
                  itemCount: 5,
                ),
              ),
              verticalGap(defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECENT ACTIVITY',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalGap(defaultPadding / 2),
              for (UnitModel model in dummyList.take(5)) ...{
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
                        padding: const EdgeInsets.fromLTRB(defaultPadding,
                            defaultPadding, defaultPadding, defaultPadding / 2),
                        child: Text(
                          model.code ?? '',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                              model.quantity ?? '',
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
                              model.date ?? '',
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
                                color: getColorByType(model.type ?? '')
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                model.type?.toUpperCase() ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: getColorByType(model.type ?? ''),
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
          const HeaderCard(),
          SearchBox(searchCtrl: _searchCtrl)
        ],
      ),
    );
  }
}
