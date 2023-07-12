import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/colors.dart';

void showPopup(
    BuildContext context, DialogType dialogType, String title, String message) {
  AwesomeDialog(
    context: context,
    dialogType: dialogType,
    animType: AnimType.bottomSlide,
    title: title,
    desc: message,
    onDismissCallback: (type) {},
    autoDismiss: false,
    btnOkOnPress: () {
      navigatorKey.currentState?.pop();
    },
    btnOkColor: primaryColor,
  ).show();
}
