import 'package:flutter/material.dart';
import 'servicos/supabase_servico.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseServico.inicializar();
  runApp(const MeuBancoApp());
}

class MeuBancoApp extends StatelessWidget {
  const MeuBancoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco Digital',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
