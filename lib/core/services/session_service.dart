import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/app_user.dart';
import '../../data/models/data_exception.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/users_provider.dart';

/// Who is signed in. Single source of truth for the current [AppUser];
/// every controller reads the user from here instead of re-fetching it.
class SessionService extends GetxService {
  SessionService({AuthProvider? auth, UsersProvider? users})
    : _auth = auth ?? Get.find<AuthProvider>(),
      _users = users ?? Get.find<UsersProvider>();

  final AuthProvider _auth;
  final UsersProvider _users;
  StreamSubscription<String?>? _authSubscription;

  /// The signed-in user's profile, or null when signed out.
  final Rxn<AppUser> user = Rxn<AppUser>();

  String? get uid => user.value?.uid ?? _auth.currentUserId;
  bool get isSignedIn => uid != null;

  @override
  void onInit() {
    super.onInit();
    _authSubscription = _auth.userIdChanges.listen(_onUserIdChanged);
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  Future<void> _onUserIdChanged(String? id) async {
    if (id == null) {
      user.value = null;
    } else if (user.value?.uid != id) {
      await refreshUser();
    }
  }

  /// Reloads the profile from the backend. Keeps the last known value on
  /// failure, so a flaky network never logs anyone out.
  Future<void> refreshUser() async {
    final id = _auth.currentUserId;
    if (id == null) {
      user.value = null;
      return;
    }
    try {
      user.value = await _users.getUser(id) ?? AppUser(uid: id, email: _auth.currentEmail ?? '');
    } on DataException {
      user.value ??= AppUser(uid: id, email: _auth.currentEmail ?? '');
    }
  }

  /// Local update after a successful write, so the UI reflects it at once.
  void updateUser(AppUser updated) => user.value = updated;

  Future<void> signOut() async {
    await _auth.signOut();
    user.value = null;
  }
}
