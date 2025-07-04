import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/services/firebase_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DEBUG LOGGING: App initialization
  if (kDebugMode) {
    print('=== EcoCura App Initialization ===');
    print('Platform: ${defaultTargetPlatform.name}');
    print('Is Web: $kIsWeb');
    print('Debug Mode: $kDebugMode');
    print('Demo Mode: $kDemoMode');
  }

  // Initialize Firebase with proper error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize Firebase services
    await FirebaseService.initialize();
    if (kDebugMode) {
      print('✅ Firebase initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Firebase initialization failed: $e');
      print('App will continue without Firebase features');
    }
  }

  // DEBUG LOGGING: Theme system check
  if (kDebugMode) {
    print('=== Theme System Debug ===');
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    print('System brightness: ${brightness.name}');
  }

  runApp(
    const ProviderScope(
      child: EcoCuraApp(),
    ),
  );
}
