import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/supabase_constants.dart';
import '../core/network/supabase_client.dart';
import '../screens/request_screen/requests_list.dart';

class NotificationController {
  RealtimeChannel? _requestsChannel;

  Future<void> initNotifications() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      // Subscribe to Realtime changes on requests table for this user
      _requestsChannel = supabaseClient.channel('public:${SupabaseConstants.requestsTable}')
        ..onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: SupabaseConstants.requestsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'receiver_uid',
            value: user.id,
          ),
          callback: (payload) {
            showNotification(
              title: 'New Order',
              body: 'You have received a new request!',
            );
          },
        )
        ..onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: SupabaseConstants.requestsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'sender_uid',
            value: user.id,
          ),
          callback: (payload) {
            final newRecord = payload.newRecord;
            final isDone = newRecord['is_done'] == true;
            if (isDone) {
              showNotification(
                title: 'Request Finished',
                body: 'Your glasses request has been completed!',
              );
            }
          },
        )
        ..subscribe();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing notifications: $e');
      }
    }
  }

  static void showNotification({
    required String title,
    required String body,
  }) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 5),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      onTap: (snack) {
        Get.back();
        Get.to(() => RequestsScreen());
      },
    );
  }

  static Future<void> sendNotificationToUser(
    String userIdentifier,
    String title,
    String body,
  ) async {
    // Displays in-app notification and logs event
    if (kDebugMode) {
      print('Sending notification to $userIdentifier: $title - $body');
    }
    showNotification(title: title, body: body);
  }

  void dispose() {
    if (_requestsChannel != null) {
      supabaseClient.removeChannel(_requestsChannel!);
    }
  }
}
