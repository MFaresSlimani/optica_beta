import 'dart:async';

import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/ticket.dart';
import '../../../../core/utils/ticket_encoder.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/request_entry.dart';
import '../../../../data/providers/printer_provider.dart';
import '../../../services/feedback_service.dart';

class PrintingController extends GetxController {
  PrintingController({required this.entry, PrinterProvider? printers, FeedbackService? feedback})
    : _printers = printers ?? Get.find<PrinterProvider>(),
      _feedback = feedback ?? Get.find<FeedbackService>();

  final RequestEntry entry;
  final PrinterProvider _printers;
  final FeedbackService _feedback;

  static const Duration scanTimeout = Duration(seconds: 12);

  final RxList<Printer> devices = <Printer>[].obs;
  final RxBool isScanning = false.obs;

  /// Address of the printer currently printing, if any.
  final RxnString printingTo = RxnString();

  StreamSubscription<List<Printer>>? _subscription;
  Timer? _scanTimer;

  late final Ticket ticket = Ticket.fromRequest(
    entry.request,
    storeName: entry.storeName.isEmpty ? AppStrings.appName.tr : entry.storeName,
    clientName: entry.senderName,
    ownerName: entry.receiverName,
  );

  TicketLabels get labels => (
    client: AppStrings.receiptClient.tr,
    storeOwner: AppStrings.receiptStoreOwner.tr,
    created: AppStrings.receiptCreated.tr,
    completed: AppStrings.receiptCompleted.tr,
    status: AppStrings.status.tr,
    pending: AppStrings.pending.tr,
    supplied: AppStrings.supplied.tr,
    notSupplied: AppStrings.notSupplied.tr,
    lenses: AppStrings.receiptLenses.tr,
    note: AppStrings.storeNote.tr,
    thanks: AppStrings.receiptThanks.tr,
  );

  @override
  void onReady() {
    super.onReady();
    scan();
  }

  Future<void> scan() async {
    await _subscription?.cancel();
    isScanning.value = true;
    _subscription = _printers.printers.listen(devices.assignAll);
    try {
      await _printers.startScan();
    } catch (_) {
      isScanning.value = false;
      return;
    }
    _scanTimer?.cancel();
    _scanTimer = Timer(scanTimeout, stopScan);
  }

  Future<void> stopScan() async {
    _scanTimer?.cancel();
    isScanning.value = false;
    await _printers.stopScan();
  }

  Future<void> printTo(Printer printer) async {
    if (printingTo.value != null) return;
    printingTo.value = printer.address ?? printer.name;
    try {
      final bytes = await TicketEncoder.encode(ticket, labels);
      await _printers.printBytes(printer, bytes);
      _feedback.showSuccess(AppStrings.printedSuccessfully.tr);
    } on DataException catch (e) {
      _feedback.showError(e.message);
    } finally {
      printingTo.value = null;
    }
  }

  @override
  void onClose() {
    _scanTimer?.cancel();
    _subscription?.cancel();
    _printers.stopScan();
    super.onClose();
  }
}
