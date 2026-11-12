import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'profile_view.dart';

/// Route entry for someone else's profile; resolves the tagged controller.
class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) => ProfileView(controllerTag: Get.arguments as String);
}
