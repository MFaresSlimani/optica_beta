import 'package:bng_optica/screens/printing/printer_list.dart';
import 'package:bng_optica/screens/request_screen/handle_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../authentication.dart';
import '../../models/request_model.dart';
import '../../models/user_model.dart';
import '../../widgets/profile_widget.dart';

class RequestDetails extends StatelessWidget {
  final Request request;
  final AuthenticationService _auth = Get.find<AuthenticationService>();

  RequestDetails({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request_details'.tr),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.usb),
                          title: Text('USB Printers & Bluetooth Printers'.tr),
                          onTap: () {
                            Get.back();
                            Get.to(() => PrintersList(
                                  request: request,
                                ));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.print))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request_Date:'.tr,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              Text(
                // format the date to be like: 21/09/2021
                DateFormat.yMMMMEEEEd().format(request.createdAt.toLocal()),
                style: GoogleFonts.abel(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Request_Time:'.tr,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              Text(
                DateFormat.jm().format(request.createdAt.toLocal()),
                style: GoogleFonts.abel(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sent_from:'.tr,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<AppUser>(
                future: _auth.getUserById(request.senderUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'This user does not exist anymore'.tr,
                    );
                  } else {
                    return ProfileWidget(userId: snapshot.data!.uid);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Store'.tr,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: _auth.getStoreById(request.storeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'.tr);
                  } else {
                    final store = snapshot.data;
                    return Text(store!.storeName,
                        style: GoogleFonts.abel(
                          fontSize: 24,
                        ));
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Details'.tr,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
              request.isDone == false
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: request.description.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            request.description[index],
                            style: GoogleFonts.abel(
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                      children: [
                        Text(
                          'Done_Glasses'.tr,
                          style: GoogleFonts.abel(
                            fontSize: 24,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: request.doneGlasses?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                request.doneGlasses![index],
                                style: GoogleFonts.abel(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Left_Glasses'.tr,
                          style: GoogleFonts.abel(
                            fontSize: 24,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: request.leftGlasses?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                request.leftGlasses![index],
                                style: GoogleFonts.abel(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              const SizedBox(height: 16),
              Text(
                'Status:'.tr,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                request.isDone ? 'Done'.tr : 'Pending'.tr,
                style: GoogleFonts.abel(
                  fontSize: 20,
                  color: request.isDone ? Colors.green : Colors.red,
                ),
              ),
              if (request.isDone) ...[
                const SizedBox(height: 16),
                Text(
                  'Done_date:'.tr,
                  style: GoogleFonts.abel(
                    fontSize: 24,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${DateFormat.yMMMMEEEEd().format(request.doneAt!.toLocal())} at ${DateFormat.jm().format(request.doneAt!.toLocal())}',
                  style: GoogleFonts.abel(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Done_message:'.tr,
                  style: GoogleFonts.abel(
                    fontSize: 24,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  request.doneMessage,
                  style: GoogleFonts.abel(
                    fontSize: 20,
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _auth.getCurrentUser()!.uid == request.receiverUid &&
              !request.isDone
          ? BottomAppBar(
              color: Theme.of(context).cardColor,
              elevation: 0,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(HandleRequestScreen(request: request));
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.brown,
                          width: 1,
                        ),
                        fixedSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFF09242A),
                      ),
                      child: Text(
                        'Handle_request'.tr,
                        style: GoogleFonts.abel(
                          fontSize: 20,
                          color: Colors.white, // set the text color to white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
