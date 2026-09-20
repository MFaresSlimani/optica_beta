import 'package:flutter/material.dart';
import 'package:get/get.dart';

// change language screen
class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change_language'.tr),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: const Text('English'),
              trailing: Get.locale == const Locale('en', 'US')
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                setState(() {});
              },
            ),
            ListTile(
              title: const Text('Français'),
              trailing: Get.locale == const Locale('fr', 'FR')
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Get.updateLocale(const Locale('fr', 'FR'));
                setState(() {});
              },
            ),
            ListTile(
              title: const Text('عربي'),
              trailing: Get.locale == const Locale('ar', 'AR')
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Get.updateLocale(const Locale('ar', 'AR'));
                setState(() {});
              },
            ),
            ListTile(
              title: const Text('ⵜⴰⵎⴰⵣⵉⵖⵜ (Tamazight)'),
              trailing: (Get.locale?.languageCode == 'kab' ||
                      Get.locale == const Locale('kab', 'KAB'))
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Get.updateLocale(const Locale('kab', 'KAB'));
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
