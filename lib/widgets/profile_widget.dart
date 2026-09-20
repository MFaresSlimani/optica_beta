import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication.dart';
import '../../models/user_model.dart';
import '../screens/profile_screens/profile_screen.dart';

// get the user id and get the details to build a widget
class ProfileWidget extends StatelessWidget {
  final String userId;

  const ProfileWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final AuthenticationService auth = Get.find<AuthenticationService>();
    return FutureBuilder<AppUser>(
      future: auth.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Center(child: Text('This user does not exist anymore'.tr)),
            ],
          );
        } else {
          AppUser user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(ProfileScreen(userId: user.uid));
              },
              child: Card(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: user.pfp != '' ? NetworkImage(user.pfp) : Image.asset('assets/profile.jpg').image),

                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.username),
                          Text(user.phoneNumber),
                          Text(user.email),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }


}