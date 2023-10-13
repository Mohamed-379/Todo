import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/app_user.dart';
import 'package:todo/providers/list_provider.dart';
import 'package:todo/providers/settings_provider.dart';
import 'package:todo/ui/screens/auth/login_screen/login_screen.dart';
import 'package:todo/ui/screens/home/tabs/settings_tab/settings_tab.dart';
import 'package:todo/ui/screens/home/tabs/tasks_list_tab/tasks_list_tab.dart';
import 'package:todo/ui/utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/add_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ListProvider listProvider;
  int currentSelectedTab = 0;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of(context);
    SettingsProvider provider = Provider.of(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: currentSelectedTab == 0 ? TasksListTab() : SettingsTab(),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor:provider.currentTheme == ThemeMode.light ? AppColors.white: AppColors.blackLight),
          child: buildButtonNav()),
      floatingActionButton: buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget buildAppBar() => AppBar(
    title: Text("Welcome ${AppUser.currentUser!.userName}"),
    toolbarHeight: MediaQuery.of(context).size.height * .1,
    actions: [
      InkWell(
        onTap: () {
          listProvider.todos.clear();
          AppUser.currentUser = null;
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.logout),
          )),
    ],
  );

  Widget buildButtonNav()
  {
   return BottomAppBar(
     notchMargin: 8,
     shape: const CircularNotchedRectangle(),
     clipBehavior: Clip.antiAliasWithSaveLayer,
     child: BottomNavigationBar(
       onTap: (index) {
         currentSelectedTab = index;
         setState(() {});
       },
       currentIndex: currentSelectedTab,
       items: const [
        BottomNavigationBarItem(icon: ImageIcon(AssetImage(AppAssets.icList)), label: ""),
        BottomNavigationBarItem(icon: ImageIcon(AssetImage(AppAssets.icSettings)), label: ""),
      ],),
   );
  }

  Widget buildFab() => FloatingActionButton(onPressed: (){
    showModalBottomSheet(context: context, isScrollControlled: true ,builder:(context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AddBottomSheet(),
      );
    },);
  },
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child:  const Icon(Icons.add),
  );
}