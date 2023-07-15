import 'dart:developer';

import 'package:alcohol_inventory/services/firestore_service.dart';
import 'package:alcohol_inventory/services/snackbar_service.dart';
import 'package:alcohol_inventory/utils/static_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../main.dart';
import '../models/user_profile.dart';

enum AuthStatus {
  notAuthenticated,
  authenticating,
  authenticated,
  error,
  forgotPwdMailSent
}

class AuthProvider extends ChangeNotifier {
  User? user;
  AuthStatus? status = AuthStatus.notAuthenticated;
  late FirebaseAuth _auth;
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    checkCurrentUserIsAuthenticated();
  }

  bool checkCurrentUserIsAuthenticated() {
    user = _auth.currentUser;
    if (user != null) {
      if (user!.emailVerified) {
        return true;
      } else {
        logoutUser();
      }
    }

    return false;
  }

  Future<void> logoutUser() async {
    try {
      status = AuthStatus.authenticating;
      notifyListeners();
      await _auth.signOut();
      user = null;
      prefs.clear();
      status = AuthStatus.notAuthenticated;
      notifyListeners();
    } catch (e) {
      SnackBarService.instance.showSnackBarError("Error Logging Out");
    }
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    try {
      status = AuthStatus.authenticating;
      notifyListeners();
      if (user != null) {
        user!.updateDisplayName(name);
      }
      status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      SnackBarService.instance.showSnackBarError("Error Logging Out");
    }
    notifyListeners();
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    if (!isEmail(email)) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return;
    }
    if (password.isEmpty) {
      SnackBarService.instance.showSnackBarError('Enter password');
      return;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;

      if (!(user?.emailVerified ?? false)) {
        SnackBarService.instance
            .showSnackBarError(StaticMessage.onEmailNotVerified);

        logoutUser();
        status = AuthStatus.notAuthenticated;
      } else {
        status = AuthStatus.authenticated;
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      user = null;
      notifyListeners();
    }
  }

  Future<bool> registerUserWithEmailAndPassword(
      UserProfile newUser, String password) async {
    status = AuthStatus.authenticating;
    notifyListeners();
    bool resp = false;
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: newUser.email!.trim(), password: password.trim());
      user = result.user;
      user!.updateDisplayName(newUser.name);
      user!.sendEmailVerification();
      newUser.id = user!.uid;
      newUser.createdAt = Timestamp.now();
      newUser.lastUpdated = Timestamp.now();
      newUser.lastLoggedIn = Timestamp.now();
      newUser.lastRestocked = 0;
      newUser.totalUnit = 0;
      newUser.isActive = false;
      await FirestoreProvider().createUser(newUser).then((value) {
        if (value) {
          SnackBarService.instance
              .showSnackBarSuccess(StaticMessage.onSuccessfullSignupMsg);
          status = AuthStatus.authenticated;
          notifyListeners();
          resp = true;
        } else {
          SnackBarService.instance
              .showSnackBarError('Error in saving user data');
          status = AuthStatus.error;
          notifyListeners();
          resp = false;
        }
      });
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      resp = false;
    }
    return resp;
  }

  Future<bool> forgotPassword(String email) async {
    if (!isEmail(email)) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return false;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      status = AuthStatus.forgotPwdMailSent;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarSuccess("Please check your mail for reset link");
      return true;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    if (newPassword.trim().isEmpty || newPassword.trim().length < 8) {
      SnackBarService.instance
          .showSnackBarError('Password must be 8 character long');
      return false;
    }

    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      bool res = false;
      user = _auth.currentUser;
      await user?.updatePassword(newPassword).then((value) {
        res = true;
        SnackBarService.instance.showSnackBarSuccess('Password changed');
      }).catchError((onError) {
        res = false;
        log(onError.toString());
        SnackBarService.instance
            .showSnackBarError('ERR : ${onError.toString()}');
      });
      status = AuthStatus.authenticated;
      notifyListeners();
      return res;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }
}
