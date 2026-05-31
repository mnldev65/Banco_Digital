import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoricoTransferenciasPage extends StatelessWidget {
  const HistoricoTransferenciasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Transferências'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transferencias')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('Nenhuma transferência realizada.'));
          }

          var listaTransferencias = snapshot.data!.docs;

          return ListView.builder(
            itemCount: listaTransferencias.length,
            itemBuilder: (context, index) {
              var dados =
                  listaTransferencias[index].data() as Map<String, dynamic>;

              String destinatario = dados['destinatario'] ?? 'Desconhecido';
              double valor = (dados['valor'] as num?)?.toDouble() ?? 0.0;
              String dataIso = dados['data'] ?? '';

              String dataFormatada = dataIso.isNotEmpty
                  ? dataIso.substring(0, 10).split('-').reversed.join('/')
                  : 'S/D';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.arrow_upward, color: Colors.red),
                  title: Text(destinatario,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Data: $dataFormatada'),
                  trailing: Text(
                    'R\$ ${valor.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/comprovante',
                        arguments: dados);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
