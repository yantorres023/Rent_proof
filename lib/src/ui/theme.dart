import 'package:flutter/material.dart';

const _seed = Color(0xFF1F5AA6);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    // 48dp minimum targets for gloved/hurried hands.
    materialTapTargetSize: MaterialTapTargetSize.padded,
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(64, 52)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(64, 48)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 12),
  );
}

/// Semantic colors used together with an icon and text, never alone.
class StatusColors {
  static Color done(ColorScheme s) => s.brightness == Brightness.light
      ? const Color(0xFF1E7A3C)
      : const Color(0xFF7ED69A);
  static Color pending(ColorScheme s) => s.onSurfaceVariant;
  static Color warning(ColorScheme s) => s.brightness == Brightness.light
      ? const Color(0xFF9A5B00)
      : const Color(0xFFFFC46B);
}
