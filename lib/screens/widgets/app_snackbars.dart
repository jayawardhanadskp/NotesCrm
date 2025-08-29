import 'package:flutter/material.dart';

class AppSnackbars {
  AppSnackbars._();

  static void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
