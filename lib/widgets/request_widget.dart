import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../authentication.dart';
import '../../models/request_model.dart';
import '../screens/request_screen/request_details.dart';

class RequestWidget extends StatelessWidget {
  final Request request;
  final bool isSentRequest;
  final AuthenticationService _authController =
      Get.find<AuthenticationService>();

  RequestWidget(
      {super.key, required this.request, required this.isSentRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Get.to(() => RequestDetails(request: request));
        },
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                // rounded corners for the top left and right of the card
                decoration: BoxDecoration(
                  color: request.isDone ? Colors.green : Colors.red,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    request.isDone ? 'Done'.tr : 'Pending'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              FutureBuilder(
                future: isSentRequest
                    ? _authController.getUserById(request.receiverUid)
                    : _authController.getUserById(request.senderUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error'.tr);
                  } else {
                    final senderName = snapshot.data!.username;
                    return ListTile(
                      leading:
                          const Icon(Icons.person, color: Color(0xFF0B2C33)),
                      title: Text(
                          isSentRequest
                              ? '${'Request_to'.tr}: $senderName'
                              : '${'Request_by'.tr}: $senderName',
                          style: const TextStyle(color: Color(0xFF0B2C33))),
                    );
                  }
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.access_time, color: Color(0xFF0B2C33)),
                title: Text(
                    '${'Request_date'.tr} : ${DateFormat.yMd().add_jm().format(request.createdAt.toLocal())}',
                    style: const TextStyle(color: Color(0xFF0B2C33))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
