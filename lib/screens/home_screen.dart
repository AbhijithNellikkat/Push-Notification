import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_app/models/user.dart';
import 'package:push_notification_app/services/firebase_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
        ),
        body: Center(
          child: StreamBuilder(
            stream: FirebaseHelper.buildViews,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final List<UserModel> users = [];
              final List<QueryDocumentSnapshot>? docs = snapshot.data?.docs;

              if (docs == null || docs.isEmpty) {
                return const Text("No Data");
              }

              for (var doc in docs) {
                if (doc.data() != null) {
                  users.add(
                      UserModel.fromJson(doc.data() as Map<String, dynamic>));
                }
              }

              return Column(
                  children:
                      users.map((e) => Text("Name is ${e.name}")).toList());
            },
          ),
        ),
      ),
    );
  }
}
