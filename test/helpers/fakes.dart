import 'dart:async';

import 'package:bng_optica/core/services/session_service.dart';
import 'package:bng_optica/data/models/app_user.dart';
import 'package:bng_optica/data/models/data_exception.dart';
import 'package:bng_optica/data/models/glasses_request.dart';
import 'package:bng_optica/data/models/lens_item.dart';
import 'package:bng_optica/data/models/store.dart';
import 'package:bng_optica/data/providers/auth_provider.dart';
import 'package:bng_optica/data/providers/order_draft_provider.dart';
import 'package:bng_optica/data/providers/preferences_provider.dart';
import 'package:bng_optica/data/providers/printer_provider.dart';
import 'package:bng_optica/data/providers/requests_provider.dart';
import 'package:bng_optica/data/providers/storage_provider.dart';
import 'package:bng_optica/data/providers/stores_provider.dart';
import 'package:bng_optica/data/providers/users_provider.dart';
import 'package:bng_optica/presentation/services/feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

// In-memory stand-ins for every provider. They implement the real classes'
// interfaces, so controllers run unchanged against them.

class FakeAuthProvider implements AuthProvider {
  FakeAuthProvider({this.currentUserId, this.currentEmail});

  @override
  String? currentUserId;
  @override
  String? currentEmail;
  Object? signInError;
  final List<String> resetEmails = [];

  @override
  Stream<String?> get userIdChanges => const Stream.empty();

  @override
  Future<String> signIn({required String email, required String password}) async {
    if (signInError != null) throw signInError!;
    currentUserId = 'uid-$email';
    currentEmail = email;
    return currentUserId!;
  }

  @override
  Future<String> signUp({
    required String email,
    required String password,
    required String username,
  }) => signIn(email: email, password: password);

  @override
  Future<void> sendPasswordReset(String email) async => resetEmails.add(email);

  @override
  Future<void> signOut() async => currentUserId = null;
}

class FakeUsersProvider implements UsersProvider {
  FakeUsersProvider([Iterable<AppUser> users = const []])
    : users = {for (final u in users) u.uid: u};

  final Map<String, AppUser> users;

  @override
  Future<AppUser?> getUser(String uid) async => users[uid];

  @override
  Future<Map<String, AppUser>> getUsers(Iterable<String> uids) async => {
    for (final id in uids)
      if (users.containsKey(id)) id: users[id]!,
  };

  @override
  Stream<AppUser> watchUser(String uid) => Stream.value(users[uid] ?? AppUser.unknown(uid));

  @override
  Future<void> upsertUser(AppUser user) async => users[user.uid] = user;

  @override
  Future<void> updateProfile(
    String uid, {
    required String username,
    required String phoneNumber,
    required String pfp,
  }) async {
    users[uid] = users[uid]!.copyWith(username: username, phoneNumber: phoneNumber, pfp: pfp);
  }

  @override
  Future<void> setStore(String uid, String? storeId) async {
    final user = users[uid];
    if (user == null) return;
    users[uid] = user.copyWith(
      isStoreOwner: storeId != null,
      storeId: storeId,
      clearStore: storeId == null,
    );
  }
}

class FakeStoresProvider implements StoresProvider {
  FakeStoresProvider([List<Store> stores = const []]) : stores = [...stores];

  final List<Store> stores;
  bool fail = false;

  @override
  Future<List<Store>> getApprovedStores() async {
    if (fail) throw const DataException('offline');
    return stores.where((s) => s.isApproved).toList();
  }

  @override
  Future<Store?> getStore(String id) async => stores.where((s) => s.id == id).firstOrNull;

  @override
  Future<Map<String, Store>> getStores(Iterable<String> ids) async => {
    for (final s in stores)
      if (ids.contains(s.id)) s.id: s,
  };

  @override
  Future<String> createStore(Store store) async {
    final id = 'store-${stores.length + 1}';
    stores.add(Store.fromMap({...store.toMap(), 'id': id}));
    return id;
  }

  @override
  Future<void> deleteStore(String id) async => stores.removeWhere((s) => s.id == id);
}

class FakeRequestsProvider implements RequestsProvider {
  FakeRequestsProvider([List<GlassesRequest> requests = const []]) : requests = [...requests];

  final List<GlassesRequest> requests;
  final List<GlassesRequest> created = [];
  final List<GlassesRequest> updated = [];
  bool fail = false;

  @override
  Future<List<GlassesRequest>> getSent(String uid) async {
    if (fail) throw const DataException('offline');
    return requests.where((r) => r.senderUid == uid).toList();
  }

  @override
  Future<List<GlassesRequest>> getReceived(String uid) async {
    if (fail) throw const DataException('offline');
    return requests.where((r) => r.receiverUid == uid).toList();
  }

  @override
  Future<GlassesRequest?> getRequest(String id) async =>
      requests.where((r) => r.id == id).firstOrNull;

  @override
  Future<String> createRequest(GlassesRequest request) async {
    if (fail) throw const DataException('offline');
    created.add(request);
    return 'req-${created.length}';
  }

  @override
  Future<void> updateRequest(GlassesRequest request) async {
    if (fail) throw const DataException('offline');
    updated.add(request);
  }

  @override
  VoidCallback subscribe({
    required String uid,
    required void Function() onReceived,
    required void Function() onCompleted,
  }) => () {};
}

class FakeStorageProvider implements StorageProvider {
  final List<String> uploaded = [];

  @override
  Future<String> uploadProfileImage({required String uid, required String filePath}) async {
    uploaded.add(filePath);
    return 'https://cdn.test/$uid/avatar.jpg';
  }

  @override
  Future<String> uploadStoreImage({required String uid, required String filePath}) async {
    uploaded.add(filePath);
    return 'https://cdn.test/$uid/${uploaded.length}.jpg';
  }
}

class FakeOrderDraftProvider implements OrderDraftProvider {
  final Map<String, List<LensItem>> drafts = {};

  @override
  List<LensItem> load(String storeId) => drafts[storeId] ?? const [];

  @override
  Future<void> save(String storeId, List<LensItem> items) async {
    // Mirrors the real provider: saving an empty order deletes the draft.
    items.isEmpty ? drafts.remove(storeId) : drafts[storeId] = [...items];
  }

  @override
  Future<void> clear(String storeId) async => drafts.remove(storeId);
}

class FakePreferencesProvider implements PreferencesProvider {
  ThemeMode themeMode = ThemeMode.light;
  String? languageCode = 'en';

  @override
  ThemeMode readThemeMode() => themeMode;

  @override
  Future<void> writeThemeMode(ThemeMode mode) async => themeMode = mode;

  @override
  String? readLanguageCode() => languageCode;

  @override
  Future<void> writeLanguageCode(String code) async => languageCode = code;
}

class FakePrinterProvider implements PrinterProvider {
  final StreamController<List<Printer>> _controller = StreamController.broadcast();
  final List<List<int>> printed = [];

  void emit(List<Printer> printers) => _controller.add(printers);

  @override
  Stream<List<Printer>> get printers => _controller.stream;

  @override
  Future<void> startScan() async {}

  @override
  Future<void> stopScan() async {}

  @override
  Future<void> printBytes(Printer printer, List<int> bytes) async => printed.add(bytes);
}

/// Records what the user would have been shown.
class RecordingFeedback extends FeedbackService {
  final List<String> successes = [];
  final List<String> errors = [];
  final List<String> infos = [];
  bool confirmResult = true;
  int confirmCalls = 0;

  @override
  void showSuccess(String message) => successes.add(message);

  @override
  void showError(String message) => errors.add(message);

  @override
  void showInfo({required String title, required String message, VoidCallback? onTap}) =>
      infos.add(title);

  @override
  Future<bool> confirm({
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
    IconData? icon,
  }) async {
    confirmCalls++;
    return confirmResult;
  }
}

/// A session already signed in as [user] (or signed out when null).
SessionService signedInSession(AppUser? user, {FakeUsersProvider? users}) {
  final session = SessionService(
    auth: FakeAuthProvider(currentUserId: user?.uid, currentEmail: user?.email),
    users: users ?? FakeUsersProvider([?user]),
  );
  session.user.value = user;
  return session;
}
