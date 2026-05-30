import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServico {
  // ─────────────────────────────────────────────────────────────
  // 🔑  Cole aqui as suas credenciais do painel do Supabase:
  //     Project Settings → API
  // ─────────────────────────────────────────────────────────────
  static const String _supabaseUrl = 'https://umnwmsfsrwomlywaaqix.supabase.co';
  static const String _supabaseAnonKey =
      'sb_publishable_k28obsEz6glIhu8CDQk9aw_SIrEzxPF';

  static Future<void> inicializar() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
