import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/app_user.dart';
import 'package:todo/providers/list_provider.dart';
import 'package:todo/ui/utils/app_theme.dart';
import 'package:todo/ui/widgets/my_text_field.dart';
import '../../../../model/todo_md.dart';
import '../../../../providers/settings_provider.dart';
import '../../../utils/app_colors.dart';

class EditScreen extends StatefulWidget
{
  static const String routeName = "editScreen";

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController editTitle = TextEditingController();
  TextEditingController editDescription = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late TodoMD model;
  late ListProvider listProvider;
  late SettingsProvider provider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of(context);
    provider = Provider.of(context);
    model = ModalRoute.of(context)!.settings.arguments as TodoMD;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("ToDo List",
        style: AppTheme.appBarTitleTextStyle,),
        toolbarHeight: MediaQuery.of(context).size.height * .2,

      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 545,
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color:provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.blackLight
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Edit Task", textAlign: TextAlign.center,
                  style: provider.currentTheme == ThemeMode.light ? AppTheme.appBarTitleTextStyle.copyWith(
                    color: AppColors.black) : AppTheme.appBarTitleTextStyle.copyWith(color: AppColors.white),),
                const SizedBox(height: 25,),
                MyTextField(controller: editTitle, hintText: "This is title"),
                const SizedBox(height: 12,),
                MyTextField(controller: editDescription,hintText: "Task details",),
                const SizedBox(height: 35,),
                Text("Select time", textAlign: TextAlign.start,
                  style:provider.currentTheme == ThemeMode.light ? const TextStyle(fontSize: 18) : const TextStyle(fontSize: 18,
                      color: AppColors.white),),
                const SizedBox(height: 30,),
                InkWell(
                  onTap: (){
                    showMyDatePicker();
                  },
                  child: Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", textAlign: TextAlign.center,
                    style: provider.currentTheme == ThemeMode.light ? const TextStyle(color: AppColors.gray, fontSize: 16) :
                    const TextStyle(color: AppColors.white, fontSize: 16)
                    ,),
                ),
                SizedBox(height: MediaQuery.of(context).size.height *0.2,),
                ElevatedButton(onPressed: (){
                  editTaskInFirestore();
                },
                style: ButtonStyle(
                  shape: const MaterialStatePropertyAll(
                    StadiumBorder(),
                  ),
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.all(18)
                  ),
                  backgroundColor: provider.currentTheme == ThemeMode.light ? const MaterialStatePropertyAll(AppColors.primary) :
                  const MaterialStatePropertyAll(AppColors.primary)
                ),
                    child: const Text("Save Changes"),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  void editTaskInFirestore() async
  {
    CollectionReference collectionReference =
    AppUser.userCollectionReference().doc(AppUser.currentUser!.id).collection(TodoMD.collectionName);

    await collectionReference.doc(model.id).update(
        {
          "id" : model.id,
          "title" : editTitle.text,
          "description" : editDescription.text,
          "date" : selectedDate,
          "isDone" : false
        }
    );
    listProvider.refreshTodosList();
    Navigator.pop(context);
  }

  void showMyDatePicker() async {
    SettingsProvider provider = Provider.of(context, listen: false);
    selectedDate = await showDatePicker(context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) =>provider.currentTheme == ThemeMode.light ? Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                onSurface: AppColors.blackLight,
                primary: AppColors.primary,
                onPrimary: AppColors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary
                  )
              )
          ),
          child: child!,
        ) : Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                onSurface: AppColors.white,
                primary: AppColors.blackLight,
                onPrimary: AppColors.white,
                surface: AppColors.blackLight,
              ),
              dialogBackgroundColor: AppColors.accentDark,
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.white
                  )
              )
          ),
          child: child!,
        )) ?? selectedDate;
    setState(() {});
  }
}