import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';

import 'date_formats.dart';
import 'ticket.dart';

/// Turns a [Ticket] into ESC/POS bytes for an 80 mm thermal printer.
abstract final class TicketEncoder {
  static Future<List<int>> encode(Ticket ticket, TicketLabels labels) async {
    final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());
    const right = PosStyles(align: PosAlign.right);
    const bold = PosStyles(bold: true);

    String statusOf(TicketLineStatus status) => switch (status) {
      TicketLineStatus.pending => labels.pending,
      TicketLineStatus.supplied => labels.supplied,
      TicketLineStatus.notSupplied => labels.notSupplied,
    };

    final bytes = <int>[
      ...generator.text(
        ticket.storeName,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1,
      ),
      ...generator.text('${labels.client}: ${ticket.clientName}'),
      ...generator.text('${labels.storeOwner}: ${ticket.ownerName}'),
      ...generator.text('${labels.created}: ${DateFormats.ticket(ticket.createdAt)}'),
      if (ticket.doneAt != null)
        ...generator.text('${labels.completed}: ${DateFormats.ticket(ticket.doneAt!)}'),
      ...generator.text(
        '${labels.status}: ${ticket.isDone ? labels.completed : labels.pending}',
        styles: bold,
        linesAfter: 1,
      ),
      ...generator.hr(),
      ...generator.text(labels.lenses, styles: const PosStyles(align: PosAlign.center, bold: true)),
      ...generator.hr(),
    ];

    for (final line in ticket.lines) {
      final item = line.item;
      bytes
        ..addAll(
          generator.row([
            PosColumn(text: item.type, width: 8, styles: bold),
            PosColumn(text: statusOf(line.status), width: 4, styles: right),
          ]),
        )
        ..addAll(
          generator.row([
            PosColumn(
              text: item.isParsed
                  ? 'SPH ${item.sphere.format()}  CYL ${item.cylinder.format()}'
                  : '',
              width: 8,
            ),
            PosColumn(text: 'x${item.quantity}', width: 4, styles: right),
          ]),
        )
        ..addAll(generator.feed(1));
    }

    bytes.addAll(generator.hr());
    if (ticket.note.isNotEmpty) {
      bytes
        ..addAll(generator.text('${labels.note}:', styles: bold))
        ..addAll(generator.text(ticket.note, linesAfter: 1));
    }
    bytes
      ..addAll(
        generator.text(
          labels.thanks,
          styles: const PosStyles(align: PosAlign.center),
          linesAfter: 2,
        ),
      )
      ..addAll(generator.text('#${ticket.reference}', styles: right))
      ..addAll(generator.cut());
    return bytes;
  }
}
