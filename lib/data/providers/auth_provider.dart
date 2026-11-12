import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/network/supabase_client.dart';
import '../models/data_exception.dart';

/// Authentication calls. Exposes plain ids and strings so nothing above the
/// data layer depends on Supabase types.
class AuthProvider {
  AuthProvider({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? supabaseClient;

  String? get currentUserId => _client.auth.currentUser?.id;
  String? get currentEmail => _client.auth.currentUser?.email;

  /// Emits the signed-in user id, or null after sign-out.
  Stream<String?> get userIdChanges =>
      _client.auth.onAuthStateChange.map((state) => state.session?.user.id);

  /// Returns the user id.
  Future<String> signIn({required String email, required String password}) {
    return _guard(() async {
      final response = await _client.auth.signInWithPassword(email: email, password: password);
      final user = response.user;
      if (user == null) throw const DataException('Sign in failed');
      return user.id;
    });
  }

  /// Creates the account and makes sure a session is active. Returns the user id.
  Future<String> signUp({
    required String email,
    required String password,
    required String username,
  }) {
    return _guard(() async {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      final user = response.user;
      if (user == null) throw const DataException('Sign up failed');
      if (response.session == null) {
        await _client.auth.signInWithPassword(email: email, password: password);
      }
      return user.id;
    });
  }

  Future<void> sendPasswordReset(String email) {
    return _guard(() => _client.auth.resetPasswordForEmail(email));
  }

  Future<void> signOut() => _guard(() => _client.auth.signOut());

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthException catch (e) {
      throw DataException(e.message, cause: e);
    } on DataException {
      rethrow;
    } catch (e) {
      throw DataException(e.toString(), cause: e);
    }
  }
}
