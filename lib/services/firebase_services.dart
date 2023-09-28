import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_app/models/user.dart';
import 'package:push_notification_app/screens/home_screen.dart';
import 'package:push_notification_app/screens/signup_screen.dart';

class FirebaseHelper {
  const FirebaseHelper._();

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<bool> saveUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential credential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return true;
      }

      // implementing firestore
      var userRef = db.collection('users').doc(credential.user!.uid);

      final now = DateTime.now();

      final String createdAt = '${now.day}-${now.month}-${now.year}';

      final String token = '';

      final userModel = UserModel(
        createdAt: createdAt,
        name: name,
        platform: Platform.operatingSystem,
        token: token,
        uid: credential.user!.uid,
      );

      await userRef.set(userModel.toJson());

      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> get buildViews =>
      db.collection("users").snapshots();

  static Widget get homeScreen {
    if (auth.currentUser != null) {
      return const HomeScreen();
    }

    return const SignUpScreen();
  }
}
