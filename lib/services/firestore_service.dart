import 'dart:developer';

import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:alcohol_inventory/services/auth_provider.dart';
import 'package:alcohol_inventory/services/snackbar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum FirestoreStatus { ideal, loading, success, failed }

enum FirestoreCollections { users }

class FirestoreProvider extends ChangeNotifier {
  late FirebaseFirestore _db;
  FirestoreStatus? status = FirestoreStatus.ideal;
  FirestoreProvider() {
    _db = FirebaseFirestore.instance;
  }

  Future<bool> createUser(UserProfile newUser) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    bool result = false;
    await _db
        .collection(FirestoreCollections.users.name)
        .doc(newUser.id)
        .set(newUser.toMap())
        .then((value) {
      log('User saved successfully');
      status = FirestoreStatus.success;
      notifyListeners();
      result = true;
    }).catchError((error) {
      log('Error on saving | ${error.message}');
      status = FirestoreStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(error.message);
      result = false;
    });
    return result;
  }

  Future<UserProfile?> getUserById(String id) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    UserProfile? user;
    await _db
        .collection(FirestoreCollections.users.name)
        .doc(id)
        .get()
        .then((value) {
      user = UserProfile.fromMap(value.data() ?? {});
      status = FirestoreStatus.success;
      notifyListeners();
    }).catchError((error) {
      log('Error on saving | ${error.message}');
      status = FirestoreStatus.failed;
      notifyListeners();

      SnackBarService.instance.showSnackBarError(error.message);
    });
    return user;
  }

  Future<bool> updateUser(UserProfile user) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    bool result = false;
    await _db
        .collection(FirestoreCollections.users.name)
        .doc(user.id)
        .update(user.toMap())
        .then((value) async {
      await AuthProvider().updateUserName(user.name ?? '');
      log('Profile update successfully');
      SnackBarService.instance
          .showSnackBarSuccess('Profile update successfully');
      status = FirestoreStatus.success;
      notifyListeners();
      result = true;
    }).catchError((error) {
      log('Error on saving | ${error.message}');
      status = FirestoreStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(error.message);
      result = false;
    });
    return result;
  }
}
