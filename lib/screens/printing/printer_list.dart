import 'dart:async';
import 'dart:developer';
import 'package:bng_optica/core/utils/receipt_printer.dart';
import 'package:bng_optica/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrintersList extends StatefulWidget {
  final Request request;
  const PrintersList({super.key, required this.request});

  @override
  State<PrintersList> createState() => _PrintersListState();
}

class _PrintersListState extends State<PrintersList> {
  final _flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;
  List<Printer> _printers = [];
  bool _isScanning = false;
  // ignore: prefer_final_fields
  String _errorMessage = '';
  StreamSubscription<List<Printer>>? _devicesStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _errorMessage = '';
    });
    _devicesStreamSubscription?.cancel();
    await _flutterThermalPrinterPlugin.getPrinters(connectionTypes: [
      ConnectionType.USB,
    ]);
    _devicesStreamSubscription = _flutterThermalPrinterPlugin.devicesStream
        .listen((List<Printer> event) {
      log(event.map((e) => e.name).toList().toString());
      setState(() {
        _isScanning = false;
        _printers = event;
        _printers
            .removeWhere((element) => element.name == null || element.name == ''
                //  ||
                // !element.name!.toLowerCase().contains('print')
                );
      });
    });
  }

  Future<void> _stopScan() async {
    _devicesStreamSubscription?.cancel();
    await _flutterThermalPrinterPlugin.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  @override
  void dispose() {
    _devicesStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Printer')),
      body: RefreshIndicator(
        onRefresh: () async {
          _startScan();
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: _isScanning ? _stopScan : _startScan,
                  child: Text(
                    _isScanning ? 'Stop Scan' : 'Scan for Printers',
                    style: GoogleFonts.abel(
                      color: const Color(0xFFB78D75),
                      fontSize: 20,
                    ),
                  )),
            ),
            Expanded(
              child: _isScanning
                  ? const Center(child: CircularProgressIndicator())
                  : _printers.isNotEmpty
                      ? ListView.builder(
                          itemCount: _printers.length,
                          itemBuilder: (context, index) {
                            final printer = _printers[index];
                            return Card(
                              color: Colors.transparent,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(
                                  printer.name ?? 'Unknown Printer',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Connected: ${printer.isConnected}',
                                ),
                                trailing: Icon(
                                  printer.isConnected ?? false
                                      ? Icons.print
                                      : Icons.print_disabled,
                                  color: printer.isConnected ?? false
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onTap: () async {
                                  if (printer.isConnected != null &&
                                      printer.isConnected!) {
                                    printReceipt(widget.request, printer);
                                  } else {
                                    final isConnected =
                                        await _flutterThermalPrinterPlugin
                                            .connect(printer);
                                    await Future.delayed(
                                        const Duration(seconds: 10));
                                    if (isConnected) {
                                      printReceipt(widget.request, printer);
                                    } else {
                                      Get.snackbar(
                                        'Connection Failed',
                                        'Could not connect to printer.',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: _errorMessage.isNotEmpty
                              ? Text(_errorMessage)
                              : const Text('No printers found'),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
