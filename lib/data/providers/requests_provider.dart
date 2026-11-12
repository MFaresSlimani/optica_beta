import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_constants.dart';
import '../../core/network/supabase_client.dart';
import '../models/data_exception.dart';
import '../models/glasses_request.dart';

class RequestsProvider {
  RequestsProvider({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? supabaseClient;

  SupabaseQueryBuilder get _table => _client.from(SupabaseConstants.requestsTable);

  Future<List<GlassesRequest>> getSent(String uid) => _list(DbColumns.senderUid, uid);

  Future<List<GlassesRequest>> getReceived(String uid) => _list(DbColumns.receiverUid, uid);

  Future<List<GlassesRequest>> _list(String column, String uid) async {
    try {
      final rows = await _table
          .select()
          .eq(column, uid)
          .order(DbColumns.createdAt, ascending: false);
      return rows.map(GlassesRequest.fromMap).toList(growable: false);
    } catch (e) {
      throw DataException('Could not load requests', cause: e);
    }
  }

  Future<GlassesRequest?> getRequest(String id) async {
    try {
      final row = await _table.select().eq(DbColumns.id, id).maybeSingle();
      return row == null ? null : GlassesRequest.fromMap(row);
    } catch (e) {
      throw DataException('Could not load request', cause: e);
    }
  }

  /// Inserts the request and returns its generated id.
  Future<String> createRequest(GlassesRequest request) async {
    try {
      final row = await _table.insert(request.toMap()).select(DbColumns.id).single();
      return row[DbColumns.id].toString();
    } catch (e) {
      throw DataException('Could not send request', cause: e);
    }
  }

  Future<void> updateRequest(GlassesRequest request) async {
    try {
      await _table.update(request.toMap()).eq(DbColumns.id, request.id);
    } catch (e) {
      throw DataException('Could not update request', cause: e);
    }
  }

  /// Realtime: calls [onReceived] when someone sends [uid] a request and
  /// [onCompleted] when one of [uid]'s requests is completed.
  /// Returns a function that unsubscribes.
  VoidCallback subscribe({
    required String uid,
    required void Function() onReceived,
    required void Function() onCompleted,
  }) {
    final channel = _client.channel('${SupabaseConstants.requestsChannel}:$uid')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: SupabaseConstants.publicSchema,
        table: SupabaseConstants.requestsTable,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: DbColumns.receiverUid,
          value: uid,
        ),
        callback: (_) => onReceived(),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: SupabaseConstants.publicSchema,
        table: SupabaseConstants.requestsTable,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: DbColumns.senderUid,
          value: uid,
        ),
        callback: (payload) {
          final wasDone = payload.oldRecord[DbColumns.isDone] == true;
          final isDone = payload.newRecord[DbColumns.isDone] == true;
          if (isDone && !wasDone) onCompleted();
        },
      )
      ..subscribe();
    return () => _client.removeChannel(channel);
  }
}
