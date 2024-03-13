import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Theme'),
              trailing: Get.isDarkMode
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
              onTap: () {}
            ),
          ],
        ),
      ),
    );
  }
}
