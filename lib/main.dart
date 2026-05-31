/*
 * TRABALHO DE [Dispositivos Moveis]
 * * EQUIPE:
*   Integrante 01(Marlon Nunes Leão - 04182685)
*   Integrante 02(Tarso Alessandro Siqueira Ferreira - 04187122)
*   Integrante 03(Lucas da Rocha Montoril - 04184677)
*   Integrante 04(jorge Lucas Pessoa Paixão/04186104)
*   Integrante 05(José Gabriel Martins de Sousa - 04185171)
 */

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
