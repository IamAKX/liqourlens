import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/theme.dart';

import 'package:flutter/material.dart';

import '../../widgets/gaps.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required TextEditingController searchCtrl,
  }) : _searchCtrl = searchCtrl;

  final TextEditingController _searchCtrl;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 130,
      child: Card(
        elevation: defaultPadding,
        margin: const EdgeInsets.all(defaultPadding),
        color: background,
        child: SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width - (2 * defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              horizontalGap(defaultPadding),
              const Icon(
                Icons.search,
                color: Colors.grey,
                size: 20,
              ),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Seach you inventory',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              horizontalGap(defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
