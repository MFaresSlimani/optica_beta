import 'package:bng_optica/core/utils/receipt_printer.dart';
import 'package:bng_optica/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';

class TicketPreview extends StatelessWidget {
  final Printer printer;
  final Request request;

  const TicketPreview({super.key, required this.printer, required this.request});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: generateReceiptBytes(request),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error generating receipt'));
        } else {
          List<int> receiptData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text('Ticket Preview')),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text('Preview Your Receipt',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Request ID: ${request.id}'),
                      Text('Created At: ${request.createdAt}'),
                      Text('Done At: ${request.doneAt ?? 'N/A'}'),
                      Text(
                          'Status: ${request.isDone ? 'Completed' : 'Pending'}'),
                      // Other request details...
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Print the receipt
                    final bool isPrinted =
                        await _printTicket(printer, receiptData);
                    if (isPrinted) {
                      Get.snackbar('Success', 'Printed successfully');
                    } else {
                      Get.snackbar('Error', 'Failed to print');
                    }
                  },
                  child: const Text('Print'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<bool> _printTicket(Printer printer, List<int> receiptData) async {
    try {
      await FlutterThermalPrinter.instance.connect(printer);
      await FlutterThermalPrinter.instance
          .printData(printer, receiptData, longData: true);
      return true;
    } catch (e) {
      print('Print failed: $e');
      return false;
    }
  }
}
