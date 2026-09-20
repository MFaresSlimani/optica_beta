import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/network/supabase_client.dart';

class StorageProvider {
  final SupabaseClient _client;

  StorageProvider({SupabaseClient? client})
      : _client = client ?? supabaseClient;

  Future<String?> uploadProfileImage({
    required String userId,
    required String fileName,
    required File file,
  }) async {
    try {
      final path = '$userId/$fileName';
      await _client.storage
          .from(SupabaseConstants.profilesBucket)
          .upload(
            path,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      return _client.storage
          .from(SupabaseConstants.profilesBucket)
          .getPublicUrl(path);
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadStoreImage({
    required String userId,
    required String fileName,
    required File file,
  }) async {
    try {
      final path = '$userId/$fileName';
      await _client.storage
          .from(SupabaseConstants.storesBucket)
          .upload(
            path,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      return _client.storage
          .from(SupabaseConstants.storesBucket)
          .getPublicUrl(path);
    } catch (e) {
      return null;
    }
  }
}
