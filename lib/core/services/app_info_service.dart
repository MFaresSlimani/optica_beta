import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Build information shown in Settings.
class AppInfoService extends GetxService {
  AppInfoService({this.version = '', this.buildNumber = ''});

  final String version;
  final String buildNumber;

  String get label => buildNumber.isEmpty ? version : '$version ($buildNumber)';

  static Future<AppInfoService> load() async {
    final info = await PackageInfo.fromPlatform();
    return AppInfoService(version: info.version, buildNumber: info.buildNumber);
  }
}
