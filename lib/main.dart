import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/kitty_app.dart';
import 'core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global environment configuration
  AppConfig.initialize();

  runApp(
    const ProviderScope(
      child: KittyApp(),
    ),
  );
}
