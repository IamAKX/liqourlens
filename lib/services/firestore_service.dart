import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum FirestoreStatus { ideal, loading, success, failed }

enum FirestoreCollections { users }

class FirestoreProvider extends ChangeNotifier {
  late FirebaseFirestore _db;
  FirestoreStatus? status = FirestoreStatus.ideal;
  DBService() {
    _db = FirebaseFirestore.instance;
  }

  // Future<bool> createUser(UserProfile newUser){
  //   _db.collection(FirestoreCollections.users.name).doc(newUser.id).set(newUser.toMap()).whenComplete(() {

  //   }).
  // }
}
