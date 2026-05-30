import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServico {
  // ─────────────────────────────────────────────────────────────
  // 🔑  Cole aqui as suas credenciais do painel do Supabase:
  //     Project Settings → API
  // ─────────────────────────────────────────────────────────────
  static const String _supabaseUrl = 'SUA_SUPABASE_URL';
  static const String _supabaseAnonKey = 'SUA_SUPABASE_ANON_KEY';

  static Future<void> inicializar() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
