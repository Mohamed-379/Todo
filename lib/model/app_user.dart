import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser
{
  static String collectionName = "users";
  late String id;
  late String userName;
  late String email;
  static AppUser? currentUser;

  AppUser({required this.id, required this.email, required this.userName});

  AppUser.fromJson(Map json)
  {
    id = json["id"];
    userName = json["userName"];
    email = json["email"];
  }

  Map<String, dynamic> toJson()
  {
    return {
      "id" : id,
      "userName" : userName,
      "email" : email,
    };
  }

  static CollectionReference<AppUser> userCollectionReference()
  {
   return FirebaseFirestore.instance.collection(AppUser.collectionName).
    withConverter<AppUser>(
      fromFirestore: (snapshot, _) {
        return AppUser.fromJson(snapshot.data()!);
      },
      toFirestore:
          (user, _)  {
        return user.toJson();
      },
    );
  }
}