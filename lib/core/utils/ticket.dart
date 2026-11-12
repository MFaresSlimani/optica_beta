import 'package:flutter/foundation.dart';

import '../../data/models/glasses_request.dart';
import '../../data/models/lens_item.dart';

enum TicketLineStatus { pending, supplied, notSupplied }

@immutable
class TicketLine {
  const TicketLine(this.item, this.status);

  final LensItem item;
  final TicketLineStatus status;
}

/// Everything printed on a thermal ticket, independent of the printer.
/// The same object renders the on-screen preview, so what you see is what
/// gets printed.
@immutable
class Ticket {
  const Ticket({
    required this.requestId,
    required this.storeName,
    required this.clientName,
    required this.ownerName,
    required this.createdAt,
    required this.isDone,
    required this.lines,
    this.doneAt,
    this.note = '',
  });

  factory Ticket.fromRequest(
    GlassesRequest request, {
    required String storeName,
    required String clientName,
    required String ownerName,
  }) {
    final lines = request.isDone
        ? [
            for (final item in request.doneItems) TicketLine(item, TicketLineStatus.supplied),
            for (final item in request.leftItems) TicketLine(item, TicketLineStatus.notSupplied),
          ]
        : [for (final item in request.items) TicketLine(item, TicketLineStatus.pending)];

    return Ticket(
      requestId: request.id,
      storeName: storeName,
      clientName: clientName,
      ownerName: ownerName,
      createdAt: request.createdAt,
      doneAt: request.doneAt,
      isDone: request.isDone,
      lines: lines,
      note: request.doneMessage.trim(),
    );
  }

  final String requestId;
  final String storeName;
  final String clientName;
  final String ownerName;
  final DateTime createdAt;
  final DateTime? doneAt;
  final bool isDone;
  final List<TicketLine> lines;
  final String note;

  /// Short, human-friendly reference (first 8 chars of the id, upper-case).
  String get reference {
    final clean = requestId.replaceAll('-', '');
    return (clean.length > 8 ? clean.substring(0, 8) : clean).toUpperCase();
  }
}

/// Translated labels printed on the ticket.
typedef TicketLabels = ({
  String client,
  String storeOwner,
  String created,
  String completed,
  String status,
  String pending,
  String supplied,
  String notSupplied,
  String lenses,
  String note,
  String thanks,
});
