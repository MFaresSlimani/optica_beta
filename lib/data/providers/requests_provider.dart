import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/network/supabase_client.dart';
import '../../models/request_model.dart';

class RequestsProvider {
  final SupabaseClient _client;

  RequestsProvider({SupabaseClient? client})
      : _client = client ?? supabaseClient;

  Future<List<Request>> getSentRequests(String senderUid) async {
    final response = await _client
        .from(SupabaseConstants.requestsTable)
        .select()
        .eq('sender_uid', senderUid)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => Request.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Request>> getReceivedRequests(String receiverUid) async {
    final response = await _client
        .from(SupabaseConstants.requestsTable)
        .select()
        .eq('receiver_uid', receiverUid)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => Request.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<String> createRequest(Request request) async {
    final map = request.toMap();
    if (request.id.isEmpty) {
      map.remove('id');
    }
    final response = await _client
        .from(SupabaseConstants.requestsTable)
        .insert(map)
        .select('id')
        .single();

    return response['id'].toString();
  }

  Future<void> updateRequest(Request request) async {
    await _client
        .from(SupabaseConstants.requestsTable)
        .update(request.toMap())
        .eq('id', request.id);
  }
}
