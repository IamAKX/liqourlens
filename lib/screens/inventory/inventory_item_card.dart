import 'package:alcohol_inventory/models/inventory_model.dart';
import 'package:alcohol_inventory/screens/inventory/product_history_screen.dart';
import 'package:alcohol_inventory/screens/inventory/update_inventory.dart';
import 'package:alcohol_inventory/utils/date_time_formatter.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';

class InventoryItemCard extends StatelessWidget {
  const InventoryItemCard({
    super.key,
    required this.inventory,
    required this.reload,
  });

  final InventoryModel inventory;
  final Function reload;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
          color: dividerColor,
        ),
        borderRadius: BorderRadius.circular(defaultPadding),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: getImageUrl(inventory.item?.images),
                    placeholder: (context, url) => Image.asset(
                      'assets/logo/loading.gif',
                      width: 80,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/dummy_bottle.jpeg',
                      width: 80,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${inventory.item?.title}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColorDark,
                            ),
                      ),
                      verticalGap(defaultPadding / 4),
                      Text(
                        '${inventory.item?.upc}',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: hintColor,
                                ),
                      ),
                    ],
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
                defaultPadding, 0, defaultPadding / 2, defaultPadding),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: '${inventory.quanty?.toStringAsFixed(1) ?? '0'}\n',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColorDark,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'In stock',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: hintColor,
                                ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Text(
                  'Updated ${DateTimeFormatter.getTimesAgo(inventory.lastUpdateTime)} ago',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: hintColor,
                      ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, ProductHistory.routePath,
                    //     arguments: inventory.item?.upc);
                    Navigator.pushNamed(
                            context, UpdateInventoryScreen.routePath,
                            arguments: inventory.item?.upc)
                        .then((value) => reload());
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    color: hintColor,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  getImageUrl(List<String>? images) {
    if (images?.isNotEmpty ?? false) {
      return images?.first ?? '';
    }
    return '';
  }
}
