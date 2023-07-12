import 'package:flutter/material.dart';
import '../../dummy/dummy_item.dart';
import '../../models/unit_model.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class ProductHistory extends StatefulWidget {
  const ProductHistory({super.key});
  static const String routePath = '/productHistory';

  @override
  State<ProductHistory> createState() => _ProductHistoryState();
}

class _ProductHistoryState extends State<ProductHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product History',
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.builder(
      itemCount: dummyList.length,
      itemBuilder: (context, index) {
        UnitModel model = dummyList.elementAt(index);
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
                  model.code ?? '',
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
                        'Tito\'s Vodka Titos Handmade Vodka, 1 L',
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
                      model.quantity ?? '',
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
                      model.date ?? '',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: textColorLight,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color:
                            getColorByType(model.type ?? '').withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        model.type?.toUpperCase() ?? '',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: getColorByType(model.type ?? ''),
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
}
