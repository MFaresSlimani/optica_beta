import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BNG Optica'),
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(child: Text('BNG Optica')),
            ListTile(
              title: Text('Home'),
            ),
            ListTile(
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'This is the home screen',
        ),
      ),
    );
  }
}
