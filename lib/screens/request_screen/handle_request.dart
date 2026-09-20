import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../authentication.dart';
import '../../models/request_model.dart';
import '../../models/user_model.dart';
import '../../notifications/notifications.dart';

class HandleRequestScreen extends StatefulWidget {
  final Request request;

  const HandleRequestScreen({super.key, required this.request});

  @override
  State<HandleRequestScreen> createState() => _HandleRequestScreenState();
}

class _HandleRequestScreenState extends State<HandleRequestScreen> {
  List<String> doneGlasses = [];
  List<String> leftGlasses = [];
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    leftGlasses = List.from(widget.request.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Handle_request'.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Select_done_glasses:'.tr,
                  style:
                      const TextStyle(fontSize: 24, color: Color(0xFFB78D75)),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                height: 250,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.request.description.length,
                  itemBuilder: (context, index) {
                    final glass = widget.request.description[index];
                    return CheckboxListTile(
                      title: Text(glass),
                      value: doneGlasses.contains(glass),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            doneGlasses.add(glass);
                          } else {
                            doneGlasses.remove(glass);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Notes'.tr,
                  style:
                      const TextStyle(fontSize: 24, color: Color(0xFFB78D75)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: 'Enter notes here'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).cardColor,
        elevation: 1,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // Update the lists based on the selected checkboxes
                    leftGlasses = widget.request.description
                        .where((glass) => !doneGlasses.contains(glass))
                        .toList();

                    widget.request.isDone = true;
                    widget.request.doneAt = DateTime.now();
                    widget.request.doneMessage = notesController.text;
                    widget.request.doneGlasses = doneGlasses;
                    widget.request.leftGlasses = leftGlasses;

                    final AuthenticationService auth = Get.find<AuthenticationService>();
                    await auth.updateRequest(widget.request);

                    final currentUid = auth.getCurrentUser()?.id ?? '';
                    AppUser seller = await auth.getUserById(currentUid);
                    await NotificationController.sendNotificationToUser(
                      widget.request.senderUid,
                      'Request finished',
                      '${seller.username} has finished your request',
                    );

                    Get.back();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
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
                  'Finished'.tr,
                  style: GoogleFonts.abel(
                    fontSize: 20,
                    color: Colors.white, // set the text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
