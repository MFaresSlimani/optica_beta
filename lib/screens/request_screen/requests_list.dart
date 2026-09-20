import 'package:bng_optica/screens/request_screen/received_requests.dart';
import 'package:bng_optica/screens/request_screen/sent_requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication.dart';
import '../../models/user_model.dart';

class RequestsScreen extends StatelessWidget {
  final AuthenticationService _authController = Get.find<AuthenticationService>();

  RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: _authController.getUserById(_authController.getCurrentUser()!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred while loading the data, please try again later or contact us.'));
        } else {
          AppUser currentUser = snapshot.data!;
          return DefaultTabController(
            length: currentUser.isStoreOwner ? 2 : 1,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Requests'.tr),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Sent_requests'.tr),
                    if (currentUser.isStoreOwner) Tab(text: 'Received_requests'.tr),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  SentRequestsScreen(),
                  if (currentUser.isStoreOwner) ReceivedRequestsScreen(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}