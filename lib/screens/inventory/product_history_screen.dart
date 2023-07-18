import 'package:alcohol_inventory/utils/date_time_formatter.dart';
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

class ProductHistory extends StatefulWidget {
  const ProductHistory({super.key, required this.upc});
  static const String routePath = '/productHistory';
  final String upc;

  @override
  State<ProductHistory> createState() => _ProductHistoryState();
}

class _ProductHistoryState extends State<ProductHistory> {
  late FirestoreProvider _firestore;
  late AuthProvider _auth;
  late ApiProvider _api;
  List<HistoryModel?> list = [];

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
      appBar: AppBar(
        title: const Text(
          'Product History',
        ),
      ),
      body: _firestore.status == FirestoreStatus.loading
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
        HistoryModel? model = list.elementAt(index);
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
                  model?.upc ?? '',
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
                        model?.name ?? '',
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
                      model?.updateValue?.toStringAsFixed(1) ?? '0',
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
                      DateTimeFormatter.formatDate(model?.lastUpdateTime),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: textColorLight,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: getColorByType(model?.updateType ?? '')
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        model?.updateType?.toUpperCase() ?? '',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: getColorByType(model?.updateType ?? ''),
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
    _firestore
        .getProductHistoryById(_auth.user?.uid ?? '', widget.upc)
        .then((value) {
      setState(() {
        list = value;
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
