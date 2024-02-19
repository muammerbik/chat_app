import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformResponsiveWidget extends StatelessWidget {
  const PlatformResponsiveWidget({super.key});

  Widget buildAndroidPlatform(BuildContext context);
  Widget buildIosPlatform(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildIosPlatform(context);
    } else {
      return buildAndroidPlatform(context);
    }
  }
}
