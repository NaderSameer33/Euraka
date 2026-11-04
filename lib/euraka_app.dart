import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'core/routers/app_routes.dart';
import 'core/theme/app_theme.dart';

class EurakaApp extends StatelessWidget {
  const EurakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(824, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            title: 'Eureka',
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context) ?? const Locale('ar'),
            builder: DevicePreview.appBuilder,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRoutes.router,
          ),
        );
      },
    );
  }
}

