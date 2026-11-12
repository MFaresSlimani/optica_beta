import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import '../models/data_exception.dart';

/// USB / Bluetooth thermal printers via `flutter_thermal_printer`.
class PrinterProvider {
  FlutterThermalPrinter get _plugin => FlutterThermalPrinter.instance;

  /// Starts a scan; results arrive on [printers].
  Future<void> startScan() {
    return _plugin.getPrinters(connectionTypes: const [ConnectionType.USB, ConnectionType.BLE]);
  }

  Stream<List<Printer>> get printers => _plugin.devicesStream.map(
    (devices) => devices.where((p) => (p.name ?? '').trim().isNotEmpty).toList(growable: false),
  );

  Future<void> stopScan() => _plugin.stopScan();

  /// Connects if needed, then prints [bytes].
  Future<void> printBytes(Printer printer, List<int> bytes) async {
    try {
      if (printer.isConnected != true) {
        final connected = await _plugin.connect(printer);
        if (!connected) throw const DataException('Could not connect to printer');
      }
      await _plugin.printData(printer, bytes, longData: true);
    } on DataException {
      rethrow;
    } catch (e) {
      throw DataException('Printing failed', cause: e);
    }
  }
}
