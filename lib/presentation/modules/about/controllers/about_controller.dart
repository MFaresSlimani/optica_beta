import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../services/feedback_service.dart';

class AboutController extends GetxController {
  AboutController({FeedbackService? feedback})
    : _feedback = feedback ?? Get.find<FeedbackService>();

  final FeedbackService _feedback;

  Future<void> openWebsite() => _open(Uri.parse(AppLinks.website));
  Future<void> openFacebook() => _open(Uri.parse(AppLinks.facebook));
  Future<void> openInstagram() => _open(Uri.parse(AppLinks.instagram));
  Future<void> sendEmail() => _open(Uri(scheme: 'mailto', path: AppLinks.email));

  Future<void> _open(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) _feedback.showError(AppStrings.somethingWentWrong.tr);
  }
}
