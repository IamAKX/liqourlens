import 'package:alcohol_inventory/screens/inventory/product_history_screen.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';

class InventoryItemCard extends StatelessWidget {
  const InventoryItemCard({
    super.key,
  });

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
                    imageUrl:
                        "https://pics.walgreens.com/prodimg/655974/450.jpg",
                    placeholder: (context, url) => Image.asset(
                      'assets/logo/loading.gif',
                      width: 80,
                    ),
                    errorWidget: (context, url, error) => SvgPicture.asset(
                      'assets/svg/notfound.svg',
                      width: 80,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tito\'s Vodka Titos Handmade Vodka, 1 L',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColorDark,
                            ),
                      ),
                      verticalGap(defaultPadding / 4),
                      Text(
                        '619947000013',
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
                    text: '35\n',
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
                  'Updated 3d ago',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: hintColor,
                      ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ProductHistory.routePath);
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
}
