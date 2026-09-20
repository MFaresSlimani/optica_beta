import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication.dart';
import '../../widgets/request_widget.dart';

class SentRequestsScreen extends StatelessWidget {
  final AuthenticationService _auth = Get.find<AuthenticationService>();

   SentRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _auth.getSentRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return RequestWidget(request: snapshot.data![index], isSentRequest: true);
            },
          );
        }
      },
    );
  }
}