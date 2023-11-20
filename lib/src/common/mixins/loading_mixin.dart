import 'package:flutter/material.dart';

mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _loadingOverlay;

  void showLoading() {
    removeLoading();

    _loadingOverlay = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Container(
            color: Colors.black12,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );

    return Overlay.of(context).insert(_loadingOverlay!);
  }

  void removeLoading() {
    _loadingOverlay?.remove();
    _loadingOverlay = null;
  }
}
