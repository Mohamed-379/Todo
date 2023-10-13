import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/app_user.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/screens/home/home_screen.dart';
import 'package:todo/ui/utils/dialog_utils.dart';
import 'package:todo/ui/widgets/my_text_field.dart';

import '../../../utils/app_colors.dart';

class RegisterScreen extends StatefulWidget
{
  static const String routeName = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //late ListProvider listProvider;
  late SettingsProvider provider;

  @override
  Widget build(BuildContext context) {
    //listProvider = Provider.of(context);
    provider = Provider.of(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),toolbarHeight: MediaQuery.of(context).size.height * .1,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .25,
              ),
              MyTextField(controller: userNameController, hintText: "username",label: const Text("User Name")),
              const SizedBox(height: 6,),
              MyTextField(controller: emailController, hintText: "email",label: const Text("Email")),
              const SizedBox(height: 6,),
              MyTextField(controller: passwordController, hintText: "password",label: const Text("Password")),
              SizedBox(height: MediaQuery.of(context).size.height * .15,),
              ElevatedButton(onPressed: (){
                register();
              }, child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Text("Register", style: TextStyle(fontSize: 18, color: AppColors.white),),
                    Spacer(),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void register() async{
    try{
      //todo: Show Loading dialog
      showLoading(context, provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.blackLight,
          TextStyle(color: provider.currentTheme == ThemeMode.light ? AppColors.black : AppColors.white));
      UserCredential userCredential =  await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      AppUser newUser = AppUser(id: userCredential.user!.uid, email: emailController.text, userName: userNameController.text);

      await registerNameInFirestore(newUser);
      AppUser.currentUser = newUser;

      //todo: Hide Loading Screen
      hideLoading(context);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }on FirebaseAuthException catch(error){
      //todo: Hide Loading Screen
      hideLoading(context);
      //todo: Show Error Dialog
      showErrorDialog(context, error.message ?? "Something went wrong. \nPlease try again later!",
          provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.blackLight,
          TextStyle(color: provider.currentTheme == ThemeMode.light ? AppColors.black : AppColors.white));
    }
  }

  Future registerNameInFirestore(AppUser user) async
  {
   CollectionReference<AppUser> collectionReference = AppUser.userCollectionReference();
   await collectionReference.doc(user.id).set(user);
  }
}