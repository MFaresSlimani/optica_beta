import 'package:bng_optica/authentication.dart';
import 'package:bng_optica/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/store_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationService _auth = Get.find<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BNG Optica'),
      ),
      drawer: ADrawer(auth: _auth),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: _auth.getStores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data!.isEmpty) {
              // if the snapshot has no data
              return ListView(
                  children: const [Center(child: Text('No stores found'))]);
            } else {
              print(snapshot.data!.length);
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  print('Data at index $index: ${snapshot.data![index]}');
                  return StoreWidget(store: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
