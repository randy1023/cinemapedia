import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2862F5),
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}
