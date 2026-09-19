import 'package:device_preview/device_preview.dart';
import 'package:euraka/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EurakaApp extends StatelessWidget {
  const EurakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: Size(426, 926),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        home: Scaffold(),
      ),
    );
  }
}
