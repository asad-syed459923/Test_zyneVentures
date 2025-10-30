import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_zyneventures/firebase_options.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return GetMaterialApp(
      title: 'ShopX',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.root,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: scheme.surfaceContainerHighest,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.primary, width: 1.6),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
