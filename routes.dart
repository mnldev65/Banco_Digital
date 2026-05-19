import 'package:flutter/material.dart';
import 'telas_banco/login.dart';
import 'telas_banco/home.dart';
import 'telas_banco/cotacao.dart';
import 'telas_banco/transferencia.dart';

class AppRotas {
  static Map<String, WidgetBuilder> obterRotas() {
    return {
      '/login': (context) => const LoginTela(),
      '/home': (context) => const Home(),
      '/cotacao': (context) => const TelaCotacao(),
      '/transferencia': (context) => const Transferencia(),
    };
  }
}