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
        home: Scaffold(
          body: Center(
            child: Text('PlatForm Euraa'),
          ),
        ),
      ),
    );
  }
}
