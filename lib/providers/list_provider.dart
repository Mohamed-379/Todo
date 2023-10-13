import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/app_user.dart';
import '../model/todo_md.dart';

class ListProvider extends ChangeNotifier
{
  List<TodoMD> todos = [];
  DateTime selectedDate = DateTime.now();

  //Todo: Get Data from FireStore
  refreshTodosList() async
  {
    //Todo: Call Collection with Convert " From 'json' to 'TodoDM' " using "withConverter" Function
    CollectionReference<TodoMD> todosCollection = AppUser.userCollectionReference().doc(AppUser.currentUser!.id).collection(TodoMD.collectionName).
    withConverter<TodoMD>(
        fromFirestore: (docs, _) {
          Map json = docs.data() as Map;
          TodoMD todo =  TodoMD.fromJson(json);
          return todo;
        },
        toFirestore: (todo, _) {
          return todo.toJson();
        },);
    QuerySnapshot<TodoMD> todoSnapshot = await todosCollection.orderBy("date").get();
    List<QueryDocumentSnapshot<TodoMD>> docs =  todoSnapshot.docs;

    todos = docs.map((docSnapShot){
      return docSnapShot.data();
    }).toList();

    todos = todos.where((todo) {
      if(todo.date.day != selectedDate.day || todo.date.month != selectedDate.month || todo.date.year != selectedDate.year)
        {
          return false;
        }
      else
      {
        return true;
      }
    }).toList();
    notifyListeners();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}