import 'package:flutter/material.dart';

class TelaCotacao extends StatelessWidget {
  const TelaCotacao({super.key});

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