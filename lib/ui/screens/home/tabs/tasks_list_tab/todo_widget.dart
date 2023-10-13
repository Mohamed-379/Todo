import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/utils/app_assets.dart';
import '../../../../../model/app_user.dart';
import '../../../../../model/todo_md.dart';
import '../../../../../providers/list_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../edit_screen/edit_screen.dart';

class TodoWidget extends StatefulWidget
{
  late TodoMD model;
  static late bool isEdit;

  TodoWidget({super.key, required this.model});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of(context);
    SettingsProvider provider = Provider.of(context);
    // TODO: implement build
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EditScreen.routeName, arguments: widget.model);
      },
      child: Container(
        margin: const EdgeInsets.all(18),
        child: Slidable(
          startActionPane: ActionPane(motion: const StretchMotion(),extentRatio: .23, children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(18),
              onPressed: (_){
                deleteTaskInFirestore();
              },
              backgroundColor: Colors.red,
              foregroundColor: AppColors.white,
              icon: Icons.delete,
              label: 'Delete',
              padding: const EdgeInsets.all(5),
            ),
          ]),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.blackLight,
            ),
            padding: const EdgeInsets.all(22),
            height: MediaQuery.of(context).size.height * .15,
            child: Row(
              children: [
                const VerticalDivider(),
                const SizedBox(width: 8,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(widget.model.title, style: AppTheme.taskTitleTextStyle),
                      const SizedBox(height: 6,),
                      Text(widget.model.description, style: provider.currentTheme == ThemeMode.light ? AppTheme.taskDescriptionTextStyle :
                      AppTheme.taskDescriptionTextStyle.copyWith(color: AppColors.white),)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primary,
                  ),
                  child: const ImageIcon(AssetImage(AppAssets.icCheck), color: AppColors.white,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteTaskInFirestore() async
  {
    CollectionReference collectionReference =
    AppUser.userCollectionReference().doc(AppUser.currentUser!.id).collection(TodoMD.collectionName);

    await collectionReference.doc(widget.model.id).delete();
    listProvider.refreshTodosList();
  }
}