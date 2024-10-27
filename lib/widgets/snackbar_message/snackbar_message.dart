import 'package:flutter/material.dart';
import 'package:scp/theme/colors/colors.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context, String message, bool isSuccess,
      {int duration = 3}) {
    final snackBar = SnackBar(
      duration: Duration(seconds: duration),
      elevation: 6,
      content: Text(
        message,
        style: const TextStyle(
            color: white,
            fontWeight: FontWeight.bold // Blue for success, Red for error
            ),
      ),
      backgroundColor: isSuccess
          ? green
          : Colors.redAccent, // Background color of the Snackbar
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
