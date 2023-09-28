import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_app/models/user.dart';
import 'package:push_notification_app/services/firebase_services.dart';
import 'package:push_notification_app/widgets/user_widget.dart';

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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List<UserModel> models = [];
              final List<QueryDocumentSnapshot>? docs = snapshot.data?.docs;
              if (docs == null || docs.isEmpty) {
                return const Text('No data');
              }

              List<Widget> widgets = [];

              for (var doc in docs) {
                models.add(
                    UserModel.fromJson(doc.data() as Map<String, dynamic>));

                final model = UserModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                );

                widgets.add(
                  UserWidget(
                    onClick: () {},
                    model: model,
                  ),
                );
              }

             return SingleChildScrollView(
              child: Column(
                children: widgets,
              ),
            );
            },
          ),
        ),
      ),
    );
  }
}
