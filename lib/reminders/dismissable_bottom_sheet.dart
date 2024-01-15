import 'dart:async';
import 'package:flutter/material.dart';

class DismissableBottomSheet {
  static Timer? _dismissTimer;
  static PersistentBottomSheetController? sheetController;
  static Widget? content;

  static show({
    required BuildContext context,
    Color? backgroundColor,
    required int durationInSeconds,
    required Widget content,
  }) {
    sheetController = showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: content,
            ),
          );
        });
    _dismissTimer = Timer(
      Duration(seconds: durationInSeconds),
      _hide,
    );
  }

  static _hide() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    sheetController?.close();
  }
}
