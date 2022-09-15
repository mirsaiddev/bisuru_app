import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

mixin MySnackbar {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    EdgeInsets margin = const EdgeInsets.all(14),
    Color backgroundColor = Colors.green,
    double radius = 14,
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      margin: margin,
      borderRadius: BorderRadius.circular(radius),
      backgroundColor: backgroundColor,
    ).show(context);
  }

  static void clear(BuildContext context) => ScaffoldMessenger.of(context).clearSnackBars();
}
