import 'package:flutter/material.dart';

mixin StatefulMixin<T extends StatefulWidget> on State<T> {
  ThemeData get theme => Theme.of(context);

  TextTheme get textTheme => theme.textTheme;

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 9),
      ),
    );
  }

  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 9),
      ),
    );
  }
}
