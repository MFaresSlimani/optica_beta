import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_constants.dart';
import '../../core/network/supabase_client.dart';
import '../models/app_user.dart';
import '../models/data_exception.dart';

class UsersProvider {
  UsersProvider({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? supabaseClient;

  SupabaseQueryBuilder get _table => _client.from(SupabaseConstants.usersTable);

  Future<AppUser?> getUser(String uid) async {
    try {
      final row = await _table.select().eq(DbColumns.id, uid).maybeSingle();
      return row == null ? null : AppUser.fromMap(row);
    } catch (e) {
      throw DataException('Could not load user', cause: e);
    }
  }

  /// Loads several users in one query, keyed by id.
  Future<Map<String, AppUser>> getUsers(Iterable<String> uids) async {
    final ids = uids.where((id) => id.isNotEmpty).toSet().toList();
    if (ids.isEmpty) return const {};
    try {
      final rows = await _table.select().inFilter(DbColumns.id, ids);
      return {for (final row in rows) AppUser.fromMap(row).uid: AppUser.fromMap(row)};
    } catch (e) {
      throw DataException('Could not load users', cause: e);
    }
  }

  /// Live profile updates. Emits [AppUser.unknown] if the row is missing.
  Stream<AppUser> watchUser(String uid) {
    return _table
        .stream(primaryKey: [DbColumns.id])
        .eq(DbColumns.id, uid)
        .map((rows) => rows.isEmpty ? AppUser.unknown(uid) : AppUser.fromMap(rows.first));
  }

  Future<void> upsertUser(AppUser user) async {
    try {
      await _table.upsert(user.toMap());
    } catch (e) {
      throw DataException('Could not save user', cause: e);
    }
  }

  Future<void> updateProfile(
    String uid, {
    required String username,
    required String phoneNumber,
    required String pfp,
  }) async {
    try {
      await _table
          .update({
            DbColumns.username: username,
            DbColumns.phoneNumber: phoneNumber,
            DbColumns.pfp: pfp,
          })
          .eq(DbColumns.id, uid);
    } catch (e) {
      throw DataException('Could not update profile', cause: e);
    }
  }

  /// Links the user to a store, or unlinks with a null [storeId].
  Future<void> setStore(String uid, String? storeId) async {
    try {
      await _table
          .update({DbColumns.storeId: storeId ?? '', DbColumns.isStoreOwner: storeId != null})
          .eq(DbColumns.id, uid);
    } catch (e) {
      throw DataException('Could not update store ownership', cause: e);
    }
  }
}
