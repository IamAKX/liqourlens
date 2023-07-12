import 'package:flutter/material.dart';

const primaryColorLight = Colors.blue;
const primaryColor = Color.fromARGB(255, 11, 79, 134); // #0B4F86
const background = Color(0xFFFFFFFF);
const backgroundDark = Color(0xFFF7FEFF);
const textColorDark = Color(0xFF344D67);
const textColorLight = Color(0xFF6B728E);
const dividerColor = Color.fromARGB(255, 228, 223, 223);
const hintColor = Colors.grey;
const textFieldFillColor = Color(0xFFF5F5F5);

const acceptedColor = Colors.green;
const rejectedColor = Colors.red;
const pendingColor = Colors.amber;
Map<int, Color> primaryColorMap = const {
  50: Color.fromRGBO(11, 79, 134, .1),
  100: Color.fromRGBO(11, 79, 134, .2),
  200: Color.fromRGBO(11, 79, 134, .3),
  300: Color.fromRGBO(11, 79, 134, .4),
  400: Color.fromRGBO(11, 79, 134, .5),
  500: Color.fromRGBO(11, 79, 134, .6),
  600: Color.fromRGBO(11, 79, 134, .7),
  700: Color.fromRGBO(11, 79, 134, .8),
  800: Color.fromRGBO(11, 79, 134, .9),
  900: Color.fromRGBO(11, 79, 134, 1),
};

MaterialColor primarySwatch = MaterialColor(0xFF0B4F86, primaryColorMap);

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Color getColorByType(String type) {
  switch (type) {
    case 'removed':
      return Colors.red;
    case 'restocked':
      return Colors.amber;
    case 'stocked':
      return Colors.green;

    default:
      return textColorDark;
  }
}
