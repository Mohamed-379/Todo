import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/cache_data/cache_data.dart';
import 'package:todo/providers/list_provider.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/screens/auth/login_screen/login_screen.dart';
import 'package:todo/ui/screens/auth/register_screen/register_screen.dart';
import 'package:todo/ui/screens/home/edit_screen/edit_screen.dart';
import 'package:todo/ui/screens/home/home_screen.dart';
import 'package:todo/ui/screens/splash/splash_screen.dart';
import 'package:todo/ui/utils/app_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheData.cacheInitialization();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(create: (_) => ListProvider()),
    ],child: MyApp(),),
      );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SettingsProvider provider = Provider.of(context);
    return MaterialApp(
      themeMode: provider.changeTheme(CacheData.getTheme(key: 'Theme')),
      theme: AppTheme.lightMode,
      darkTheme: AppTheme.darkMode,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        EditScreen.routeName: (_) => EditScreen()
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}