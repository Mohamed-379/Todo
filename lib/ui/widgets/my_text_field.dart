import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/settings_provider.dart';

import '../utils/app_colors.dart';

class MyTextField extends StatelessWidget
{
  TextEditingController controller;
  String? hintText;
  Widget? label;

  MyTextField({this.hintText, required this.controller, this.label});

  @override
  Widget build(BuildContext context) {
    SettingsProvider provider = Provider.of(context);
    // TODO: implement build
    return TextField(
      style: TextStyle(color: provider.currentTheme == ThemeMode.light ? AppColors.blackLight : AppColors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: provider.currentTheme == ThemeMode.light ? AppColors.blackLight : AppColors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: provider.currentTheme == ThemeMode.light ? AppColors.blackLight : AppColors.white)
        ),
        label: label,
        labelStyle: provider.currentTheme == ThemeMode.light ? const TextStyle(color: AppColors.black) : const TextStyle(color: AppColors.white)
      ),
    );
  }
}