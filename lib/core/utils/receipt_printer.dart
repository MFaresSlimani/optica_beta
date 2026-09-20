import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../authentication.dart';
import '../../models/request_model.dart';

Future<List<int>> generateReceiptBytes(Request request) async {
  final profile = await CapabilityProfile.load();
  final AuthenticationService auth = Get.find<AuthenticationService>();
  final generator = Generator(PaperSize.mm80, profile);
  final store = await auth.getStoreById(request.storeId);
  final seller = await auth.getUserById(request.receiverUid);
  final client = await auth.getUserById(request.senderUid);

  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  final String createdAtFormatted = formatter.format(request.createdAt);
  final String doneAtFormatted =
      request.doneAt != null ? formatter.format(request.doneAt!) : "N/A";

  List<int> bytes = [];

  // Store name
  bytes += generator.text(
    store?.storeName ?? 'Optica Store',
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
    ),
    linesAfter: 1,
  );

  // Basic information about the request
  bytes += generator.text("Client: ${client.username}",
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text("Store Owner: ${seller.username}",
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text("Created At: $createdAtFormatted",
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text("Done At: $doneAtFormatted",
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text(
    "Status: ${request.isDone ? "Completed" : "Pending"}",
    styles: const PosStyles(align: PosAlign.left, bold: true),
    linesAfter: 1,
  );

  // Table Header
  bytes += generator.hr();
  bytes += generator.text(
    "glasses_Description".tr,
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      underline: true,
    ),
  );
  bytes += generator.hr();

  // Determine which list to use based on request status
  final glassesList = request.isDone
      ? [...request.doneGlasses ?? [], ...request.leftGlasses ?? []]
      : request.description;

  for (var glass in glassesList) {
    final cylIndex = glass.indexOf("CYL");
    final bracketIndex = glass.indexOf("(x");

    if (cylIndex != -1 && bracketIndex != -1) {
      final part1 = glass.substring(0, cylIndex).trim();
      final part2 = glass.substring(cylIndex, bracketIndex).trim();
      final part3 = glass.substring(bracketIndex).trim();

      bytes += generator.row([
        PosColumn(
          text: part1,
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text:
              request.isDone && (request.doneGlasses?.contains(glass) ?? false)
                  ? "Done"
                  : "Pending",
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: part2.replaceAll(RegExp(r'\s+'), ''),
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: part3.trim(),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: "",
          width: 12,
          styles: const PosStyles(align: PosAlign.left),
        ),
      ]);
    }
  }

  // Table Footer
  bytes += generator.hr();

  // Seller's note (Final Message)
  if (request.doneMessage.isNotEmpty) {
    bytes += generator.text(
      "Seller's Note:",
      styles: const PosStyles(align: PosAlign.left, bold: true),
    );
    bytes += generator.text(
      request.doneMessage,
      styles: const PosStyles(align: PosAlign.left),
      linesAfter: 1,
    );
  }

  // Thank you message
  bytes += generator.text(
    "Thank you for choosing Optica!",
    styles: const PosStyles(align: PosAlign.center),
    linesAfter: 4,
  );

  // Tiny Request ID and Store ID at the bottom right
  bytes += generator.text(
    "Request ID: ${request.id}",
    styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1),
  );
  bytes += generator.text(
    "Store ID: ${request.storeId}",
    styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1),
  );

  bytes += generator.cut();

  return bytes;
}

void printReceipt(Request request, Printer printer) async {
  final bytes = await generateReceiptBytes(request);
  FlutterThermalPrinter thermalPrinter = FlutterThermalPrinter.instance;
  await thermalPrinter.printData(printer, bytes, longData: true);
}
