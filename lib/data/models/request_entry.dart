import 'package:flutter/foundation.dart';

import 'app_user.dart';
import 'glasses_request.dart';
import 'store.dart';

/// A request plus the people and store it refers to, resolved once so list
/// rows and detail screens never fetch names one by one.
@immutable
class RequestEntry {
  const RequestEntry({required this.request, this.store, this.sender, this.receiver});

  final GlassesRequest request;
  final Store? store;
  final AppUser? sender;
  final AppUser? receiver;

  String get storeName => store?.name ?? '';
  String get senderName => sender?.displayName ?? '';
  String get receiverName => receiver?.displayName ?? '';

  RequestEntry withRequest(GlassesRequest updated) {
    return RequestEntry(request: updated, store: store, sender: sender, receiver: receiver);
  }
}
