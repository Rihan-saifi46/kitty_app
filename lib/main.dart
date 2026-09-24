import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/kitty_app.dart';
import 'core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow font loading with offline bundled assets priority
  GoogleFonts.config.allowRuntimeFetching = true;

  // Configure system navigation and status bars to seamlessly blend into emerald splash
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF05241C),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize global environment configuration
  AppConfig.initialize();

  runApp(
    const ProviderScope(
      child: KittyApp(),
    ),
  );
}
