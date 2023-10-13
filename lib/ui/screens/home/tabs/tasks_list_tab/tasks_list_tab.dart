import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/screens/home/tabs/tasks_list_tab/todo_widget.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:todo/ui/utils/app_colors.dart';
import '../../../../../providers/list_provider.dart';

class TasksListTab extends StatefulWidget {

  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  late ListProvider listProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listProvider.refreshTodosList();
    });
  }

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of(context);
    SettingsProvider provider = Provider.of(context);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .13,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(flex: 3,child: Container(color: provider.currentTheme == ThemeMode.light ?  AppColors.primary :
                  AppColors.blackLight,)),
                  Expanded(flex: 7,child: Container(color: provider.currentTheme == ThemeMode.light ? AppColors.accent :
                    AppColors.accentDark,)),
                ],
              ),
              CalendarTimeline(
                initialDate: listProvider.selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateSelected: (date) {
                  listProvider.selectedDate = date;
                  listProvider.refreshTodosList();
                },
                leftMargin: 20,
                monthColor: AppColors.white,
                dayColor: provider.currentTheme == ThemeMode.light ? AppColors.primary : AppColors.white,
                activeDayColor: provider.currentTheme == ThemeMode.light ? AppColors.primary : AppColors.white,
                activeBackgroundDayColor: provider.currentTheme == ThemeMode.light ? AppColors.white : AppColors.primaryDark,
                dotsColor: AppColors.transparent,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
            child: ListView.builder(
                itemCount: listProvider.todos.length,
                itemBuilder: (context, index) {
                  index = index;
                  return TodoWidget(model: listProvider.todos[index],);
                }
            ),
          ),
        ),
      ],
    );
  }
}