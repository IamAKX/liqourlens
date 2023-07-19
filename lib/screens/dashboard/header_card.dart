import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/show_popup.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class HeaderCard extends StatefulWidget {
  const HeaderCard({
    super.key,
    required this.totalUnits,
    required this.lastRestocked,
    required this.lastRestockedItemName,
  });

  final double totalUnits;
  final double lastRestocked;
  final String lastRestockedItemName;

  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(defaultPadding),
                elevation: defaultPadding,
                color: Colors.white,
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.totalUnits.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        'Total units',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.fromLTRB(
                    0, defaultPadding, defaultPadding, defaultPadding),
                elevation: defaultPadding,
                color: Colors.white,
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              // widget.lastRestocked.toStringAsFixed(1),
                              widget.lastRestockedItemName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    // fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                            ),
                          ),
                          Visibility(
                            visible: widget.lastRestockedItemName.isNotEmpty,
                            child: IconButton(
                              onPressed: () {
                                showPopup(
                                    context,
                                    DialogType.info,
                                    'Last Restocked',
                                    '${widget.lastRestocked.toStringAsFixed(1)} units\n${widget.lastRestockedItemName}');
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.amber,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Last Restocked',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
