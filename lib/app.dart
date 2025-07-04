import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'shared/providers/theme_provider.dart';

// Demo mode flag - set to true to use mock auth and avoid Firestore issues
const bool kDemoMode = true;

class EcoCuraApp extends ConsumerWidget {
  const EcoCuraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // FIXED: Force light theme to prevent black background issues
    // final themeMode = ref.watch(themeModeProvider);
    const themeMode = ThemeMode.light;

    // DEBUG LOGGING: Theme mode tracking
    if (kDebugMode) {
      print('=== App Theme Debug ===');
      print('FIXED: Forced theme mode to light');
      print('Current theme mode: ${themeMode.name}');
      print('System brightness: ${MediaQuery.platformBrightnessOf(context).name}');
      print('Effective theme: light (forced)');
    }

    return MaterialApp.router(
      title: 'EcoCura - Recycle Radar',
      theme: AppTheme.lightTheme,
      // FIXED: Remove dark theme to prevent automatic switching
      // darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
