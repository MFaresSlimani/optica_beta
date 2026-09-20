class SupabaseConstants {
  // Supabase Project Credentials
  // Can be overridden at build time via --dart-define SUPABASE_URL=... and --dart-define SUPABASE_ANON_KEY=...
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gajnctcaqqtlplmnevqz.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdham5jdGNhcXF0bHBsbW5ldnF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk4MzQ1NDgsImV4cCI6MjEwNTQxMDU0OH0.HXcUEdwQQBIchAl9OsA_8ODW_y47gwQSUTUR8SV6yNA',
  );

  // Table Names
  static const String usersTable = 'users';
  static const String storesTable = 'stores';
  static const String requestsTable = 'requests';

  // Storage Bucket Names
  static const String profilesBucket = 'profiles';
  static const String storesBucket = 'stores';
}
