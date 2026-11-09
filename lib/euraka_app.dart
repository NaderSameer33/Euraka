import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'core/routers/app_routes.dart';
import 'core/services/get_it_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/logic/theme_cubit.dart';
import 'core/theme/logic/theme_state.dart';

class EurakaApp extends StatelessWidget {
  const EurakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = getIt<ThemeCubit>();

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          bloc: themeCubit,
          builder: (context, themeState) {
            return ToastificationWrapper(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: MaterialApp.router(
                  title: 'Eureka',
                  debugShowCheckedModeBanner: false,
                  locale: const Locale('ar'),
                  builder: (context, child) {
                    final previewChild = DevicePreview.appBuilder(context, child);
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: previewChild,
                    );
                  },
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.themeMode,
                  routerConfig: AppRoutes.router,
                  supportedLocales: const [
                    Locale('ar'),
                    Locale('en'),
                  ],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
