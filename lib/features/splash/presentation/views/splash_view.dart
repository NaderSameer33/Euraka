import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/routers/app_router_name.dart';
import '../components/splash_ambient_glow.dart';
import '../components/splash_loading_indicator.dart';
import '../components/splash_logo_widget.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _bottomFadeAnimation;
  late final Animation<double> _pulseAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnimation = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 35.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutCubic,
      ),
    );

    _bottomFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  void _startAnimationSequence() {
    _entryController.forward().then((_) {
      if (mounted) {
        _pulseController.repeat(reverse: true);
        _scheduleNavigation();
      }
    });
  }

  void _scheduleNavigation() {
    _navigationTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        context.go(AppRouterName.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SplashAmbientGlow(
                pulseAnimation: _pulseAnimation,
              ),
            ),
            Center(
              child: SplashLogoWidget(
                scaleAnimation: _scaleAnimation,
                fadeAnimation: _fadeAnimation,
                slideAnimation: _slideAnimation,
              ),
            ),
            Positioned(
              bottom: 48.h,
              child: SplashLoadingIndicator(
                fadeAnimation: _bottomFadeAnimation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

