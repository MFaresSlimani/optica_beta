import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_constants.dart';
import '../../core/network/supabase_client.dart';
import '../models/data_exception.dart';

/// Image uploads. Returns public URLs.
class StorageProvider {
  StorageProvider({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? supabaseClient;

  Future<String> uploadProfileImage({required String uid, required String filePath}) {
    return _upload(SupabaseConstants.profilesBucket, uid, filePath);
  }

  Future<String> uploadStoreImage({required String uid, required String filePath}) {
    return _upload(SupabaseConstants.storesBucket, uid, filePath);
  }

  Future<String> _upload(String bucket, String uid, String filePath) async {
    // Timestamped names: two photos called image.jpg never overwrite each other.
    final extension = filePath.contains('.') ? filePath.split('.').last.toLowerCase() : 'jpg';
    final path = '$uid/${DateTime.now().microsecondsSinceEpoch}.$extension';
    try {
      final storage = _client.storage.from(bucket);
      await storage.upload(path, File(filePath), fileOptions: const FileOptions(upsert: true));
      return storage.getPublicUrl(path);
    } catch (e) {
      throw DataException('Could not upload image', cause: e);
    }
  }
}
