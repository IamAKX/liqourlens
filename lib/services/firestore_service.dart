import 'dart:developer';

import 'package:alcohol_inventory/models/history_model.dart';
import 'package:alcohol_inventory/models/inventory_item_view_model.dart';
import 'package:alcohol_inventory/models/inventory_model.dart';
import 'package:alcohol_inventory/models/user_profile.dart';
import 'package:alcohol_inventory/services/auth_provider.dart';
import 'package:alcohol_inventory/services/snackbar_service.dart';
import 'package:alcohol_inventory/utils/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum FirestoreStatus { ideal, loading, success, failed }

enum FirestoreCollections { users, inventory, history, drinkCollection }

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
      log(value.data().toString());
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

  Future<bool> updateUserPartially(
      String userId, Map<String, dynamic> user) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    bool result = false;
    await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .update(user)
        .then((value) async {
      log('Profile update successfully');

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

  Future<InventoryModel?> getInventoryByUpc(String userId, String upc) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    InventoryModel? inventory;
    log('$userId / $upc');
    await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.inventory.name)
        .doc(upc)
        .get()
        .then((value) {
      inventory = InventoryModel.fromMap(value.data() ?? {});
      log(inventory.toString());
      status = FirestoreStatus.success;
      notifyListeners();
    }).catchError((error) {
      log('Error on saving | ${error.message}');
      status = FirestoreStatus.failed;
      notifyListeners();

      SnackBarService.instance.showSnackBarError(error.message);
    });
    return inventory;
  }

  Future<bool?> updateInventory(
      String userId, String upc, InventoryModel inventory) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    bool res = false;
    await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.inventory.name)
        .doc(upc)
        .set(inventory.toMap())
        .then((value) async {
      Map<String, dynamic> userParams = {};
      userParams['lastRestocked'] = inventory.updateValue;
      userParams['totalUnit'] = FieldValue.increment(inventory.updateValue!);
      userParams['lastUpdated'] = inventory.lastUpdateTime;
      userParams['lastRestockedItemName'] = inventory.item?.title;

      await _db
          .collection(FirestoreCollections.users.name)
          .doc(userId)
          .update(userParams);

      DocumentReference history = _db
          .collection(FirestoreCollections.users.name)
          .doc(userId)
          .collection(FirestoreCollections.history.name)
          .doc();
      HistoryModel model = HistoryModel(
        id: history.id,
        name: inventory.item?.title,
        quantity: inventory.updateValue,
        lastUpdateTime: inventory.lastUpdateTime,
        updateType: inventory.updateType,
        updateValue: inventory.updateValue,
        upc: inventory.item?.upc,
      );
      await history.set(model.toMap()).then((value) {
        res = true;
        status = FirestoreStatus.success;
        SnackBarService.instance
            .showSnackBarSuccess('Inventory updated successfully');
        notifyListeners();
      }).catchError((onError) {
        log('Error on saving | ${onError.message}');
        status = FirestoreStatus.failed;
        notifyListeners();
        res = false;
        SnackBarService.instance.showSnackBarError(onError.message);
      });
    }).catchError((error) {
      log('Error on saving | $error');
      status = FirestoreStatus.failed;
      notifyListeners();
      res = false;
      SnackBarService.instance.showSnackBarError(error);
    });
    return res;
  }

  Future<List<InventoryModel>> getAllItemsInInventory(String userId) async {
    List<InventoryModel> list = [];
    status = FirestoreStatus.loading;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.inventory.name)
        .get();

    list = querySnapshot.docs
        .map((item) => InventoryModel.fromMap(item.data()))
        .toList();
    status = FirestoreStatus.success;
    notifyListeners();
    return list;
  }

  Future<List<HistoryModel>> getHistoryByUser(String userId) async {
    List<HistoryModel> list = [];
    status = FirestoreStatus.loading;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.history.name)
        .orderBy('lastUpdateTime', descending: true)
        .get();

    list = querySnapshot.docs
        .map((item) => HistoryModel.fromMap(item.data()))
        .toList();
    status = FirestoreStatus.success;
    notifyListeners();
    return list;
  }

  Future<List<HistoryModel>> getLimitedHistoryByUser(
      String userId, int limit) async {
    List<HistoryModel> list = [];
    status = FirestoreStatus.loading;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.history.name)
        .orderBy('lastUpdateTime', descending: true)
        .limit(limit)
        .get();

    list = querySnapshot.docs
        .map((item) => HistoryModel.fromMap(item.data()))
        .toList();
    status = FirestoreStatus.success;
    notifyListeners();
    return list;
  }

  Future<List<HistoryModel>> getLimitedDeleteHistoryByUser(
      String userId, int limit) async {
    List<HistoryModel> list = [];
    status = FirestoreStatus.loading;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.history.name)
        .where('updateType', isEqualTo: ModificationType.removed.name)
        .orderBy('lastUpdateTime', descending: true)
        .limit(limit)
        .get();

    list = querySnapshot.docs
        .map((item) => HistoryModel.fromMap(item.data()))
        .toList();
    status = FirestoreStatus.success;
    notifyListeners();
    return list;
  }

  Future<List<HistoryModel>> getDeleteHistoryByUser(String userId) async {
    List<HistoryModel> list = [];
    status = FirestoreStatus.loading;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.history.name)
        .where('updateType', isEqualTo: ModificationType.removed.name)
        .orderBy('lastUpdateTime', descending: true)
        .get();

    list = querySnapshot.docs
        .map((item) => HistoryModel.fromMap(item.data()))
        .toList();
    status = FirestoreStatus.success;
    notifyListeners();
    return list;
  }

  Future<List<HistoryModel>> getProductHistoryById(
      String userId, String upc) async {
    List<HistoryModel> list = [];
    status = FirestoreStatus.loading;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.history.name)
        .where('upc', isEqualTo: upc)
        .orderBy('lastUpdateTime', descending: true)
        .get();

    list = querySnapshot.docs
        .map((item) => HistoryModel.fromMap(item.data()))
        .toList();
    status = FirestoreStatus.success;
    notifyListeners();
    return list;
  }

  Future<void> clearInventory(String userId) async {
    status = FirestoreStatus.loading;
    notifyListeners();

    QuerySnapshot<Map<String, dynamic>> inventorySnapshots = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.inventory.name)
        .get();
    inventorySnapshots.docs.forEach((element) async {
      await element.reference.update({
        'quanty': 0.0,
        'updateType': ModificationType.removed.name,
        'updateValue': 0.0,
        'lastUpdateTime': Timestamp.now()
      });
    });

    QuerySnapshot<Map<String, dynamic>> historySnapshots = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.history.name)
        .get();

    historySnapshots.docs.forEach((element) async {
      await element.reference.delete();
    });

    await updateUserPartially(userId, {
      'lastRestocked': 0.0,
      'lastRestockedItemName': '',
      'lastUpdated': Timestamp.now(),
      'totalUnit': 0.0,
    });
  }

  Future<bool?> addInventoryItem(String userId, Set<String?> itemSet) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    bool res = false;
    await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.drinkCollection.name)
        .doc('stock')
        .set({'items': itemSet}).then((value) async {
      res = true;
    }).catchError((error) {
      log('Error on saving | $error');
      status = FirestoreStatus.failed;
      notifyListeners();
      res = false;
      SnackBarService.instance.showSnackBarError(error);
    });
    status = FirestoreStatus.success;
    notifyListeners();
    return res;
  }

  Future<List<String>?> getInventoryItem(String userId) async {
    status = FirestoreStatus.loading;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirestoreCollections.users.name)
        .doc(userId)
        .collection(FirestoreCollections.drinkCollection.name)
        .get();

    status = FirestoreStatus.success;
    notifyListeners();

    InventoryItemViewModel model =
        InventoryItemViewModel.fromMap(querySnapshot.docs.first.data());

    List<String>? list = model.items;
    list?.sort(
      (a, b) => a.compareTo(b),
    );
    status = FirestoreStatus.success;
    notifyListeners();
    return list;
  }
}
