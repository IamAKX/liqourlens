import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';

import '../../dummy/dummy_item.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class RemovedHistory extends StatefulWidget {
  const RemovedHistory({super.key});
  static const String routePath = '/removedHistory';

  @override
  State<RemovedHistory> createState() => _RemovedHistoryState();
}

class _RemovedHistoryState extends State<RemovedHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearchSwitch(
        keepAppBarColors: false,
        backgroundColor: Colors.white,
        animation: (child) => AppBarAnimationSlideLeft(
            milliseconds: 600, withFade: false, percents: 1.0, child: child),
        onChanged: (value) {},
        appBarBuilder: (context) => AppBar(
          title: const Text(
            'Removed Items',
          ),
          actions: const [
            AppBarSearchButton(
              buttonHasTwoStates: false,
            )
          ],
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.builder(
      itemCount: dummyList.length,
      itemBuilder: (context, index) => Card(
        elevation: defaultPadding / 2,
        margin: const EdgeInsets.symmetric(
            vertical: defaultPadding / 2, horizontal: defaultPadding),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dummyList.elementAt(index).date ?? '',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              verticalGap(defaultPadding / 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dummyList.elementAt(index).name ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: textColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  horizontalGap(defaultPadding),
                  Text(
                    dummyList.elementAt(index).quantity ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }
}
