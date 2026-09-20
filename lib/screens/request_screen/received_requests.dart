import 'package:bng_optica/widgets/request_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication.dart';

class ReceivedRequestsScreen extends StatelessWidget {
  final AuthenticationService _auth = Get.find<AuthenticationService>();

   ReceivedRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _auth.getReceivedRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return RequestWidget(request: snapshot.data![index], isSentRequest: false);
            },
          );
        }
      },
    );
  }
}
