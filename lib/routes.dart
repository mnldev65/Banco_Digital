import 'package:flutter/material.dart';
import 'package:banco_digital_flutter/telas_banco/login.dart';
import 'package:banco_digital_flutter/telas_banco/cadastro.dart';
import 'package:banco_digital_flutter/telas_banco/esqueci_senha.dart';
import 'package:banco_digital_flutter/telas_banco/home.dart';
import 'package:banco_digital_flutter/telas_banco/cotacao.dart';
import 'package:banco_digital_flutter/telas_banco/transferencia.dart';

class AppRoutes {
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String esqueciSenha = '/esqueci-senha';
  static const String home = '/home';
  static const String cotacao = '/cotacao';
  static const String transferencia = '/transferencia';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginTela());

      case cadastro:
        return MaterialPageRoute(builder: (_) => const CadastroTela());

      case esqueciSenha:
        return MaterialPageRoute(builder: (_) => const EsqueciSenhaTela());

      case home:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => Home(
            nomeUsuario: args?['nomeUsuario'] ?? 'Usuário',
            saldo: (args?['saldo'] as num?)?.toDouble() ?? 0.0,
          ),
        );

      case cotacao:
        return MaterialPageRoute(builder: (_) => const TelaCotacao());

      case transferencia:
        return MaterialPageRoute(builder: (_) => const Transferencia());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
