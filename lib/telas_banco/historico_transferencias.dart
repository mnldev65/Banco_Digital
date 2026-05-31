import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoricoTransferenciasPage extends StatefulWidget {
  const HistoricoTransferenciasPage({super.key});

  @override
  State<HistoricoTransferenciasPage> createState() =>
      _HistoricoTransferenciasPageState();
}

class _HistoricoTransferenciasPageState
    extends State<HistoricoTransferenciasPage> {
  late Future<List<Map<String, dynamic>>> _futureTransferencias;

  @override
  void initState() {
    super.initState();
    _futureTransferencias = _buscarTransferencias();
  }

  Future<List<Map<String, dynamic>>> _buscarTransferencias() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return [];

    final resultado = await Supabase.instance.client
        .from('transferencias')
        .select()
        .eq('usuario_id', uid)
        .order('criado_em', ascending: false);

    return List<Map<String, dynamic>>.from(resultado);
  }

  String _formatarData(String? dataIso) {
    if (dataIso == null || dataIso.isEmpty) return 'S/D';
    try {
      final dt = DateTime.parse(dataIso).toLocal();
      final dia = dt.day.toString().padLeft(2, '0');
      final mes = dt.month.toString().padLeft(2, '0');
      final hora = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$dia/$mes/${dt.year} às $hora:$min';
    } catch (_) {
      return 'S/D';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Transferências'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureTransferencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text('Erro ao carregar transferências.',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {
                      _futureTransferencias = _buscarTransferencias();
                    }),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final lista = snapshot.data ?? [];

          if (lista.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.swap_horiz, size: 70, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Nenhuma transferência realizada.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureTransferencias = _buscarTransferencias();
              });
              await _futureTransferencias;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final dados = lista[index];
                final destinatario =
                    dados['destinatario'] as String? ?? 'Desconhecido';
                final valor = (dados['valor'] as num?)?.toDouble() ?? 0.0;
                final dataFormatada =
                    _formatarData(dados['criado_em'] as String?);
                final status = dados['status'] as String? ?? 'concluida';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_upward, color: Colors.red),
                    ),
                    title: Text(destinatario,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(dataFormatada,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                        if (status != 'concluida')
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: status == 'pendente'
                                  ? Colors.orange[100]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status[0].toUpperCase() + status.substring(1),
                              style: TextStyle(
                                fontSize: 11,
                                color: status == 'pendente'
                                    ? Colors.orange[800]
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                      ],
                    ),
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
            ),
          );
        },
      ),
    );
  }
}
