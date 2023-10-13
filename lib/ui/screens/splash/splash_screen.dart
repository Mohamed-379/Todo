import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/screens/auth/login_screen/login_screen.dart';
import 'package:todo/ui/utils/app_assets.dart';

class SplashScreen extends StatefulWidget {

  static const String routeName = "splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SettingsProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    },);
  }
  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);

    return const Scaffold(
      body: Center(
        child: Image(image: AssetImage(AppAssets.splashLogo)),
      ),
    );
  }
}