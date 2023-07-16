import 'package:alcohol_inventory/utils/date_time_formatter.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/history_model.dart';
import '../../services/api_provider.dart';
import '../../services/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/snackbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  static const String routePath = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  late ApiProvider _api;
  List<HistoryModel> list = [];
  List<HistoryModel> backUpList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _firestore.status = FirestoreStatus.ideal;
        _api.status = ApiStatus.ideal;
        _auth.status = AuthStatus.notAuthenticated;
        loadScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    _firestore = Provider.of<FirestoreProvider>(context);
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBarWithSearchSwitch(
        keepAppBarColors: false,
        backgroundColor: Colors.white,
        animation: (child) => AppBarAnimationSlideLeft(
            milliseconds: 300, withFade: false, percents: 1.0, child: child),
        onChanged: (value) {
          setState(() {
            list.clear();
            if (value.isEmpty) {
              list.addAll(backUpList);
            } else {
              list.addAll(
                backUpList
                    .where((element) =>
                        element.name
                            ?.toLowerCase()
                            .contains(value.toLowerCase()) ??
                        false)
                    .toList(),
              );
            }
          });
        },
        appBarBuilder: (context) => AppBar(
          title: const Text(
            'History',
          ),
          actions: const [
            AppBarSearchButton(
              buttonHasTwoStates: false,
            )
          ],
        ),
      ),
      body: _api.status == ApiStatus.loading ||
              _firestore.status == FirestoreStatus.loading
          ? showLoader(context)
          : list.isEmpty
              ? showEmptyList(context)
              : getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        HistoryModel? item = list.elementAt(index);
        return Card(
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
                  item.upc ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        item.name ?? '',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: textColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    horizontalGap(defaultPadding),
                    Text(
                      '${item.updateValue}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                      DateTimeFormatter.formatDate(item.lastUpdateTime),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: textColorLight,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: getColorByType(item.updateType ?? '')
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item.updateType?.toUpperCase() ?? '',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: getColorByType(item.updateType ?? ''),
                            ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void loadScreen() async {
    _firestore.getHistoryByUser(_auth.user?.uid ?? '').then((value) {
      setState(() {
        list = value;
        backUpList.addAll(list);
      });
    });
  }

  showLoader(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo/loading.gif',
            width: 100,
            height: 100,
          ),
          verticalGap(defaultPadding),
          Text(
            'Fetching details, please wait...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  showEmptyList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/notfound.svg',
            width: 100,
          ),
          verticalGap(defaultPadding),
          Text(
            'No item found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }
}
