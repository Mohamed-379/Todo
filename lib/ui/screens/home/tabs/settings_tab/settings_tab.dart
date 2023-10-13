import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/cache_data/cache_data.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/utils/app_colors.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late bool isDark;

  @override
  Widget build(BuildContext context) {
    SettingsProvider provider = Provider.of(context);
    isDark = provider.isDark();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text("Dark Mode", style:provider.currentTheme == ThemeMode.light ? const TextStyle(color: AppColors.black, fontSize: 22) :
                const TextStyle(color: AppColors.white, fontSize: 22)),
                const Spacer(),
                Switch(value: isDark, onChanged: (value) {
                  if(!isDark) {
                      provider.changeTheme(true);
                      provider.notifyListeners();
                      CacheData.setTheme(key: 'Theme', value: provider.isDark());
                    }
                  else
                    {
                      provider.changeTheme(false);
                      provider.notifyListeners();
                      CacheData.setTheme(key: 'Theme', value: provider.isDark());
                    }
                  },),
              ],
            ),
          )
        ],
      ),
    );
  }
}