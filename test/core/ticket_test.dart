import 'package:bng_optica/core/utils/ticket.dart';
import 'package:bng_optica/data/models/glasses_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/sample_data.dart';

void main() {
  Ticket ticketFor(GlassesRequest request) => Ticket.fromRequest(
    request,
    storeName: 'Vision Plus',
    clientName: 'Yacine',
    ownerName: 'Amina',
  );

  test('pending request lists every ordered line as pending', () {
    final ticket = ticketFor(Sample.pendingRequest);
    expect(ticket.isDone, isFalse);
    expect(ticket.lines.map((l) => l.status), everyElement(TicketLineStatus.pending));
    expect(ticket.lines.map((l) => l.item), Sample.pendingRequest.items);
  });

  test('completed request lists supplied lines first, then not supplied', () {
    final ticket = ticketFor(Sample.completedRequest);
    expect(ticket.lines.map((l) => l.status), [
      TicketLineStatus.supplied,
      TicketLineStatus.supplied,
      TicketLineStatus.notSupplied,
    ]);
    expect(ticket.note, isNotEmpty);
    expect(ticket.doneAt, Sample.completedRequest.doneAt);
  });

  test('reference is the first 8 id characters, upper-case, no dashes', () {
    expect(ticketFor(Sample.completedRequest).reference, 'B7D1E4A0');
  });
}
