import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    publishableKey: SupabaseConstants.supabaseAnonKey,
  );
}

SupabaseClient get supabaseClient => Supabase.instance.client;
