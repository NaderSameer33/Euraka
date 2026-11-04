import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,

      builder: (context) => const EurakaApp(),
    ),
  );
}

class EurakaApp extends StatelessWidget {
  const EurakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(),
    );
  }
}
