import 'package:device_preview/device_preview.dart';

import 'package:euraka/euraka_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,

      builder: (context) => const EurakaApp(),
    ),
  );
}
