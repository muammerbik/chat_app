import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/platform_widgets/platform_responsive_widgets.dart';
import 'package:flutter/cupertino.dart';

class PlatformResponsiveAlertDialog extends PlatformResponsiveWidget {
  final String title;
  final String contents;
  final String okButonText;
  final String? cancelButonText;

  const PlatformResponsiveAlertDialog(
      {required this.title,
      required this.contents,
      required this.okButonText,
      this.cancelButonText});

  Future<bool> showAllDialog(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false)
        : await showDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidPlatform(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
      title: Text(title),
      content: Text(contents),
      actions: dialogButtonSetting(context),
    );
  }

  @override
  Widget buildIosPlatform(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(contents),
      actions: dialogButtonSetting(context),
    );
  }

  List<Widget> dialogButtonSetting(BuildContext context) {
    final List<Widget> allButtons = [];

    if (Platform.isIOS) {
      if (cancelButonText != null) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelButonText!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        CupertinoDialogAction(
          child: Text(okButonText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButonText != null) {
        allButtons.add(
          TextButton(
            child: Text(cancelButonText!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(okButonText),
        ),
      );
    }
    return allButtons;
  }
}
