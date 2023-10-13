import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier
{
  ThemeMode currentTheme = ThemeMode.light;

  bool isDark() => currentTheme == ThemeMode.dark;

  ThemeMode changeTheme(bool isDark)
  {
    return currentTheme = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}