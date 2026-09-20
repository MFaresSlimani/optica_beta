import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/network/supabase_client.dart';
import '../../models/user_model.dart';

class UsersProvider {
  final SupabaseClient _client;

  UsersProvider({SupabaseClient? client}) : _client = client ?? supabaseClient;

  Future<AppUser?> getUserById(String userId) async {
    final response = await _client
        .from(SupabaseConstants.usersTable)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return AppUser.fromMap(response);
  }

  Stream<AppUser> getUserStream(String userId) {
    return _client
        .from(SupabaseConstants.usersTable)
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((dataList) {
          if (dataList.isEmpty) {
            return AppUser(
              uid: userId,
              username: '',
              email: '',
              isStoreOwner: false,
              isRestricted: false,
              pfp: '',
              phoneNumber: '',
              fcmtoken: '',
            );
          }
          return AppUser.fromMap(dataList.first);
        });
  }

  Future<void> createUser(AppUser user) async {
    await _client.from(SupabaseConstants.usersTable).upsert(user.toMap());
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _client
        .from(SupabaseConstants.usersTable)
        .update(data)
        .eq('id', userId);
  }
}
