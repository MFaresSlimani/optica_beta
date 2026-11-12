import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_constants.dart';
import '../../core/network/supabase_client.dart';
import '../models/data_exception.dart';
import '../models/store.dart';

class StoresProvider {
  StoresProvider({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? supabaseClient;

  SupabaseQueryBuilder get _table => _client.from(SupabaseConstants.storesTable);

  Future<List<Store>> getApprovedStores() async {
    try {
      final rows = await _table
          .select()
          .eq(DbColumns.isApproved, true)
          .order(DbColumns.createdAt, ascending: false);
      return rows.map(Store.fromMap).toList(growable: false);
    } catch (e) {
      throw DataException('Could not load stores', cause: e);
    }
  }

  Future<Store?> getStore(String id) async {
    try {
      final row = await _table.select().eq(DbColumns.id, id).maybeSingle();
      return row == null ? null : Store.fromMap(row);
    } catch (e) {
      throw DataException('Could not load store', cause: e);
    }
  }

  /// Loads several stores in one query, keyed by id.
  Future<Map<String, Store>> getStores(Iterable<String> ids) async {
    final unique = ids.where((id) => id.isNotEmpty).toSet().toList();
    if (unique.isEmpty) return const {};
    try {
      final rows = await _table.select().inFilter(DbColumns.id, unique);
      return {for (final row in rows) Store.fromMap(row).id: Store.fromMap(row)};
    } catch (e) {
      throw DataException('Could not load stores', cause: e);
    }
  }

  /// Inserts the store and returns its generated id.
  Future<String> createStore(Store store) async {
    try {
      final row = await _table.insert(store.toMap()).select(DbColumns.id).single();
      return row[DbColumns.id].toString();
    } catch (e) {
      throw DataException('Could not create store', cause: e);
    }
  }

  Future<void> deleteStore(String id) async {
    try {
      await _table.delete().eq(DbColumns.id, id);
    } catch (e) {
      throw DataException('Could not delete store', cause: e);
    }
  }
}
