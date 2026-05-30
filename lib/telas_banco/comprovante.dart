import 'package:flutter/material.dart';

class ComprovantePage extends StatelessWidget {
  const ComprovantePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dados =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String destinatario = dados['destinatario'] ?? 'Desconhecido';
    double valor = (dados['valor'] as num?)?.toDouble() ?? 0.0;
    String dataIso = dados['data'] ?? '';

    String dataFormatada = dataIso.isNotEmpty
        ? dataIso.substring(0, 10).split('-').reversed.join('/')
        : 'Sem data';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprovante de Transferência'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Transferência Realizada',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 32, thickness: 1.2),
                const Text('Destinatário',
                    style: TextStyle(color: Colors.grey)),
                Text(
                  destinatario,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                const Text('Valor', style: TextStyle(color: Colors.grey)),
                Text(
                  'R\$ ${valor.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 16),
                const Text('Data da Operação',
                    style: TextStyle(color: Colors.grey)),
                Text(
                  dataFormatada,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
