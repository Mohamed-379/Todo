import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme
{
  static const TextStyle appBarTitleTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white);
  static const TextStyle taskTitleTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary);
  static const TextStyle taskDescriptionTextStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.blackLight);
  static const TextStyle buttonSheetTitleTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.blackLight);

  static ThemeData lightMode = ThemeData(
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: AppColors.white),elevation: 0, titleTextStyle: appBarTitleTextStyle
      ,backgroundColor: AppColors.primary),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.gray,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(size: 32),
      unselectedIconTheme: IconThemeData(size: 32),
    ),
    dividerTheme: const DividerThemeData(thickness: 3, color: AppColors.primary, endIndent: 6, indent: 6, ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(shape: StadiumBorder(side: BorderSide(color: AppColors.white, width: 4)),),
    scaffoldBackgroundColor: AppColors.accent
  );
  static ThemeData darkMode = ThemeData(
      primaryColor: AppColors.primaryDark,
      appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: AppColors.white),elevation: 0, titleTextStyle: appBarTitleTextStyle
          ,backgroundColor: AppColors.blackLight),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(size: 32),
        unselectedIconTheme: IconThemeData(size: 32),
      ),
      dividerTheme: const DividerThemeData(thickness: 3, color: AppColors.primary, endIndent: 6, indent: 6, ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(shape:StadiumBorder(side:BorderSide(color: AppColors.blackLight, width: 4)),),
      scaffoldBackgroundColor: AppColors.accentDark
  );
}