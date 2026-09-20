import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/providers/auth_provider.dart';
import 'data/providers/requests_provider.dart';
import 'data/providers/storage_provider.dart';
import 'data/providers/stores_provider.dart';
import 'data/providers/users_provider.dart';
import 'models/request_model.dart';
import 'models/store_model.dart';
import 'models/user_model.dart';

extension SupabaseUserExt on User {
  String get uid => id;
}

class AuthenticationService extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final UsersProvider _usersProvider = UsersProvider();
  final StoresProvider _storesProvider = StoresProvider();
  final RequestsProvider _requestsProvider = RequestsProvider();
  final StorageProvider _storageProvider = StorageProvider();

  // Fetch a user from Supabase using their user ID
  Future<AppUser> getUserById(String userId) async {
    final user = await _usersProvider.getUserById(userId);
    if (user != null) return user;
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

  // Fetch a store from Supabase using the store ID
  Future<Store?> getStoreById(String storeId) async {
    return await _storesProvider.getStoreById(storeId);
  }

  Stream<AppUser> getUserStream(String userId) {
    return _usersProvider.getUserStream(userId);
  }

  // Fetch the store owner's details using the store owner's ID
  Future<AppUser?> getStoreOwner(String storeOwnerId) async {
    return getUserById(storeOwnerId);
  }

  // Get current authenticated user
  User? getCurrentUser() {
    return _authProvider.currentUser;
  }

  Future<void> setToken([String token = '']) async {
    final uid = _authProvider.currentUser?.id;
    if (uid != null && token.isNotEmpty) {
      await _usersProvider.updateUser(uid, {'fcmtoken': token});
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _authProvider.signIn(
        email: email.trim(),
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('AuthException signing in: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      return null;
    }
  }

  // get sent requests
  Future<List<Request>> getSentRequests() async {
    final currentUserUid = _authProvider.currentUser?.id ?? '';
    if (currentUserUid.isEmpty) return [];
    return await _requestsProvider.getSentRequests(currentUserUid);
  }

  // get received requests
  Future<List<Request>> getReceivedRequests() async {
    final currentUserUid = _authProvider.currentUser?.id ?? '';
    if (currentUserUid.isEmpty) return [];
    return await _requestsProvider.getReceivedRequests(currentUserUid);
  }

  Future<User?> signUp(
    String email,
    String password, {
    String username = '',
    String phoneNumber = '',
  }) async {
    try {
      final response = await _authProvider.signUp(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user != null) {
        // Guarantee session is active so AuthWrapper transitions directly to HomeScreen
        if (_authProvider.currentSession == null) {
          try {
            await _authProvider.signIn(
              email: email.trim(),
              password: password,
            );
          } catch (_) {
            // Ignore if already active
          }
        }

        final defaultUsername = email.trim().split('@').first;
        final appUser = AppUser(
          uid: user.id,
          email: email.trim(),
          username:
              username.trim().isNotEmpty ? username.trim() : defaultUsername,
          phoneNumber: phoneNumber.trim(),
          pfp: '',
          fcmtoken: '',
          isStoreOwner: false,
          isRestricted: false,
          storeId: '',
        );

        await _usersProvider.createUser(appUser);
      }

      return user;
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('AuthException signing up: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing up: $e');
      }
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _authProvider.resetPasswordForEmail(email: email.trim());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending password reset email: $e');
      }
      return false;
    }
  }

  Future<void> signOut() async {
    await _authProvider.signOut();
  }

  // get all approved stores
  Future<List<Store>> getStores() async {
    return await _storesProvider.getStores();
  }

  Future<String> createStore(Store store) async {
    final storeId = await _storesProvider.createStore(store);
    await _usersProvider.updateUser(store.storeOwnerUid, {
      'store_id': storeId,
      'is_store_owner': true,
    });
    return storeId;
  }

  Future<void> deleteStore(String storeId, String ownerUid) async {
    await _storesProvider.deleteStore(storeId);
    await _usersProvider.updateUser(ownerUid, {
      'store_id': '',
      'is_store_owner': false,
    });
  }

  Future<String> createRequest(Request request) async {
    return await _requestsProvider.createRequest(request);
  }

  Future<void> updateRequest(Request request) async {
    await _requestsProvider.updateRequest(request);
  }

  Future<void> updateProfile({
    required String username,
    required String phoneNumber,
    required String pfp,
  }) async {
    final uid = _authProvider.currentUser?.id;
    if (uid != null) {
      await _usersProvider.updateUser(uid, {
        'username': username,
        'phone_number': phoneNumber,
        'pfp': pfp,
      });
    }
  }

  Future<String?> uploadProfileImage(File file, String fileName) async {
    final uid = _authProvider.currentUser?.id ?? 'anonymous';
    return await _storageProvider.uploadProfileImage(
      userId: uid,
      fileName: fileName,
      file: file,
    );
  }

  Future<String?> uploadStoreImage(File file, String fileName) async {
    final uid = _authProvider.currentUser?.id ?? 'anonymous';
    return await _storageProvider.uploadStoreImage(
      userId: uid,
      fileName: fileName,
      file: file,
    );
  }
}
