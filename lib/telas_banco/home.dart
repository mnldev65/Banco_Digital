import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String nomeUsuario;
  final double saldo;
  
  const Home({
    super.key,
    required this.nomeUsuario,
    required this.saldo,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela de Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            
          },
          child: const Text('Ir para Home'),
        ),
      ),
    );
  }
}