import 'package:flutter/material.dart';

class SnackBarService {
  late BuildContext _buildContext;
  static SnackBarService instance = SnackBarService();

  SnackBarService();

  set buildContext(BuildContext context) {
    _buildContext = context;
  }

  void showSnackBarError(String message) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSnackBarSuccess(String message) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showSnackBarInfo(String message) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
