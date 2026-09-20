import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/store_model.dart';
import '../screens/store_screens/store_screen.dart';

class StoreWidget extends StatelessWidget {
  final Store store;

  const StoreWidget({required this.store, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Hero(
          tag: store.storeName,
          child: Material(
            child: InkWell(
              onTap: () {
                Get.to(
                  StoreScreen(store: store),
                );
              },
              child: SizedBox(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        width: 400,
                        height: 250,
                        color: Colors.transparent,
                        child: store.storePictures == null || store.storePictures!.isEmpty
                            ? Image.network(
                                'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                store.storePictures![0],
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        store.storeName,
                        style: GoogleFonts.abel(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}