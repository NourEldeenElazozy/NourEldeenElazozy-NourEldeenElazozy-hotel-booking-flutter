import 'package:flutter/material.dart';

void showErrorMsg({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.shade800,
      behavior: SnackBarBehavior.floating,
    )
  );
}
