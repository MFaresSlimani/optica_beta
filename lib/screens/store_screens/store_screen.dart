import 'package:bng_optica/screens/request_screen/make_request.dart';
import 'package:bng_optica/widgets/profile_widget.dart';
import '../../authentication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_strings.dart';
import '../../models/store_model.dart';
import 'images_viewer.dart';

class StoreScreen extends StatefulWidget {
  final Store store;

  const StoreScreen({required this.store, super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late Store store;

  @override
  void initState() {
    super.initState();
    store = widget.store;
  }

  Future<void> refreshStore() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Update the store data
      store = widget.store;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshStore,
      child: Scaffold(
        appBar: AppBar(
          title: Text(store.storeName),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 200,
              child: store.storePictures!.isEmpty || store.storePictures == null
                  ? Image.network(
                      'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
                      fit: BoxFit.cover,
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return FullScreenImage(store.storePictures!);
                        }));
                      },
                      child: PhotoViewGallery.builder(
                        itemCount: store.storePictures!.length,
                        builder: (context, index) {
                          return PhotoViewGalleryPageOptions(
                            imageProvider:
                                NetworkImage(store.storePictures![index]),
                            minScale: PhotoViewComputedScale.contained * 1.0,
                            maxScale: PhotoViewComputedScale.contained * 1.0,
                          );
                        },
                        scrollPhysics: const BouncingScrollPhysics(),
                        backgroundDecoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                store.storeName,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description'.tr,
                    style: GoogleFonts.abel(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(store.storeDetails),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 20),
                  Text(store.storeLocation),
                ],
              ),
            ),
            // store owner details: Profile picture, name, phone number, email
            ProfileWidget(userId: store.storeOwnerUid),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).cardColor,
          elevation: 0,
          child: store.storeOwnerUid != Get.find<AuthenticationService>().getCurrentUser()?.id
              ? Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Contact_Store'.tr),
                              content: Text('Call_or_Email?'.tr),
                              actions: [
                                TextButton(
                                  child: Text('Call'.tr),
                                  onPressed: () {
                                    Uri phoneUri = Uri(
                                      scheme: 'tel',
                                      path: store.storeOwnerPhoneNumber,
                                    );
                                    launchUrl(phoneUri);
                                  },
                                ),
                                TextButton(
                                  child: Text('Email'.tr),
                                  onPressed: () {
                                    Uri emailUri = Uri(
                                      scheme: 'mailto',
                                      path: store.storeOwnerEmail,
                                    );
                                    launchUrl(emailUri);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                          backgroundColor: Colors.brown),
                      child: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(
                            () => GlassesScreen(store: store),
                            transition: Transition.cupertino,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.brown,
                            width: 1,
                          ),
                          fixedSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFF09242A),
                        ),
                        child: Text(
                          AppStrings.makeOrder.tr,
                          style: GoogleFonts.abel(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Alert dialog to confirm deletion
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppStrings.deleteStore.tr),
                            content: Text(AppStrings.areYouSure.tr),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  final auth = Get.find<AuthenticationService>();
                                  final currentUid = auth.getCurrentUser()?.id ?? '';
                                  await auth.deleteStore(store.storeId, currentUid);
                                  Get.back(); // close dialog
                                  Get.back(); // leave store screen
                                },
                                child: Text('Yes'.tr),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('No'.tr),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.brown,
                        width: 1,
                      ),
                      fixedSize: const Size.fromHeight(50),
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Delete_store'.tr,
                      style: GoogleFonts.abel(
                        fontSize: 20,
                        color: Colors.white, // set the text color to white
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
