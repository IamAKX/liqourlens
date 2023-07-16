import 'package:alcohol_inventory/utils/static_messages.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});
  static const String routePath = '/aboutUs';

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: const [Text(StaticMessage.aboutUs)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            '© ${DateTime.now().year} LiquorLens',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                ),
          ),
        ),
      ],
    );
  }
}
