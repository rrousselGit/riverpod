import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeSettings>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeSettings> {
  @override
  ThemeSettings build() {
    return ThemeSettings(mode: ThemeMode.system, primaryColor: Colors.blue);
  }

  void toggle() {
    state = state.copyWith(mode: state.mode.toggle);
  }

  void setDarkTheme() {
    state = state.copyWith(mode: ThemeMode.dark);
  }

  void setLightTheme() {
    state = state.copyWith(mode: ThemeMode.light);
  }

  void setSystemTheme() {
    state = state.copyWith(mode: ThemeMode.system);
  }

  void setPrimaryColor(Color color) {
    state = state.copyWith(primaryColor: color);
  }
}

class ThemeSettings {
  ThemeSettings({
    required this.mode,
    required this.primaryColor,
  });

  final ThemeMode mode;
  final Color primaryColor;

  ThemeSettings copyWith({
    ThemeMode? mode,
    Color? primaryColor,
  }) {
    return ThemeSettings(
      mode: mode ?? this.mode,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}

extension ToggleTheme on ThemeMode {
  ThemeMode get toggle {
    switch (this) {
      case ThemeMode.dark:
        return ThemeMode.light;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.system:
        return ThemeMode.system;
    }
  }
}
