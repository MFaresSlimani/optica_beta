import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../core/constants/app_strings.dart';

/// Full-screen, pinch-to-zoom photo viewer.
class StoreGalleryView extends StatelessWidget {
  const StoreGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ({List<String> pictures, int index});
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: Get.back<void>,
          icon: const Icon(Icons.close_rounded),
          tooltip: AppStrings.close.tr,
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: args.pictures.length,
        pageController: PageController(initialPage: args.index),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        builder: (_, index) => PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(args.pictures[index]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
        ),
      ),
    );
  }
}
