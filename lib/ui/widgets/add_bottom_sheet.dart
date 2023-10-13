import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/app_user.dart';
import 'package:todo/model/todo_md.dart';
import 'package:todo/providers/settings_provider.dart';
import '../../../providers/list_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import 'my_text_field.dart';

class AddBottomSheet extends StatefulWidget
{
  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late ListProvider listProvider;


  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of(context);
    SettingsProvider provider = Provider.of(context);
    // TODO: implement build
    return Container(
      color: provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.blackLight,
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * .45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Add new task", style:provider.currentTheme == ThemeMode.light ? AppTheme.buttonSheetTitleTextStyle :
            AppTheme.buttonSheetTitleTextStyle.copyWith(color:  AppColors.white), textAlign: TextAlign.center,),
          const SizedBox(height: 16,),
          MyTextField(hintText: "Enter task title here...", controller: titleController,),
          const SizedBox(height: 8,),
          MyTextField(hintText: "Enter task description here...", controller: descriptionController,),
          const SizedBox(height: 16,),
          Text("Select date", style: provider.currentTheme == ThemeMode.light ? AppTheme.buttonSheetTitleTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.normal) :
          AppTheme.buttonSheetTitleTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.normal, color: AppColors.white)),
          InkWell(
            onTap: (){
              showMyDatePicker();
            },
            child: Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", style: provider.currentTheme == ThemeMode.light ?
            AppTheme.buttonSheetTitleTextStyle.copyWith(fontWeight: FontWeight.normal, color: AppColors.gray) :
            AppTheme.buttonSheetTitleTextStyle.copyWith(fontWeight: FontWeight.normal, color: AppColors.white),
                textAlign: TextAlign.center),
          ),
          const Spacer(),
          ElevatedButton(onPressed: (){
            addTodoToFirebase();
          },style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(AppColors.primary)
          ), child: const Text("Add"),)
        ],
      ),
    );
  }

  //Todo: Set Data in Firestore
  void addTodoToFirebase() async {
    // Todo: Create Collection
    CollectionReference todosCollectionRef =
    AppUser.userCollectionReference().doc(AppUser.currentUser!.id).collection(TodoMD.collectionName);
    // Todo: Create Empty Document
     DocumentReference newEmptyDocu =todosCollectionRef.doc();
    //Todo: Set Data in Document as Key and Value "Map"
     await newEmptyDocu.set({
         "id": newEmptyDocu.id,
         "title": titleController.text,
         "description": descriptionController.text,
         "date": selectedDate,
         "isDone": false,
       });
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