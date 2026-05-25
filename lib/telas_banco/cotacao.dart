import 'package:flutter/material.dart';

class TelaCotacao extends StatelessWidget {
  const TelaCotacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotação de Moedas'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.euro_symbol, size: 60, color: Colors.orange[700]),
              const SizedBox(height: 20),
              const Text(
                'Tela de Cotação',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Integrante 4 fará a integração com a API',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
