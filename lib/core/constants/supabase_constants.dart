/// Supabase project settings, table, bucket and column names.
///
/// URL and anon key can be overridden at build time:
/// `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`.
/// The anon key is a public, RLS-restricted key (see supabase_schema.sql).
abstract final class SupabaseConstants {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gajnctcaqqtlplmnevqz.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdham5jdGNhcXF0bHBsbW5ldnF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk4MzQ1NDgsImV4cCI6MjEwNTQxMDU0OH0.HXcUEdwQQBIchAl9OsA_8ODW_y47gwQSUTUR8SV6yNA',
  );

  // Tables
  static const String usersTable = 'users';
  static const String storesTable = 'stores';
  static const String requestsTable = 'requests';

  // Storage buckets
  static const String profilesBucket = 'profiles';
  static const String storesBucket = 'stores';

  // Realtime
  static const String publicSchema = 'public';
  static const String requestsChannel = 'public:requests';
}

/// Column names shared by several providers.
abstract final class DbColumns {
  static const String id = 'id';
  static const String senderUid = 'sender_uid';
  static const String receiverUid = 'receiver_uid';
  static const String createdAt = 'created_at';
  static const String isApproved = 'is_approved';
  static const String isDone = 'is_done';
  static const String storeId = 'store_id';
  static const String isStoreOwner = 'is_store_owner';
  static const String username = 'username';
  static const String phoneNumber = 'phone_number';
  static const String pfp = 'pfp';
}
