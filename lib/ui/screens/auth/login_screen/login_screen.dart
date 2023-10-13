import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/screens/auth/register_screen/register_screen.dart';
import 'package:todo/ui/widgets/my_text_field.dart';

import '../../../../model/app_user.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/dialog_utils.dart';
import '../../home/home_screen.dart';

class LoginScreen extends StatefulWidget
{
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SettingsProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("Login"),toolbarHeight: MediaQuery.of(context).size.height * .1,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .25,
              ),
              Text("Welcome back !", style: provider.currentTheme == ThemeMode.light ?
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold) :
              const TextStyle( color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold),),
              MyTextField(controller: emailController, hintText: "email", label: const Text("Email"),),
              const SizedBox(height: 6,),
              MyTextField(controller: passwordController, hintText: "password", label: const Text("Password"),),
              const SizedBox(height: 26,),
              ElevatedButton(onPressed: (){
                login();
              }, child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Text("Login", style: TextStyle(fontSize: 18, color: AppColors.white),),
                    Spacer(),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 18),
                child: InkWell(onTap: (){
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                },
                    child: const Text("Create account", style: TextStyle(color: Colors.grey, fontSize: 16),)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login() async{
    try{
      //todo: Show Loading dialog
      showLoading(context, provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.blackLight,
      TextStyle(color: provider.currentTheme == ThemeMode.light ? AppColors.black : AppColors.white));
      UserCredential userCredential =  await FirebaseAuth.instance.
      signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      AppUser currentUser = await getUserFromFirebase(userCredential.user!.uid);
      AppUser.currentUser = currentUser;

      //todo: Hide Loading Screen
      hideLoading(context);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }on FirebaseAuthException catch(error){
      //todo: Hide Loading Screen
      hideLoading(context);
      //todo: Show Error Dialog
      showErrorDialog(context, error.message ?? "Something went wrong. \nPlease try again later!",
          provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.blackLight,TextStyle(color: provider.currentTheme == ThemeMode.light ? AppColors.black : AppColors.white));
    }
  }

  Future<AppUser> getUserFromFirebase(String id) async {
    CollectionReference<AppUser> collectionReference = AppUser.userCollectionReference();
    DocumentSnapshot<AppUser> documentSnapshot = await collectionReference.doc(id).get();
    return documentSnapshot.data()!;
  }
}