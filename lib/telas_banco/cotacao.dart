import 'package:flutter/material.dart';
import '../servicos/api_servico.dart';

class TelaCotacao extends StatefulWidget {
  const TelaCotacao({super.key});

  @override
  State<TelaCotacao> createState() => _TelaCotacaoState();
}

class _TelaCotacaoState extends State<TelaCotacao> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar = 0;
  double euro = 0;

  final api = CurrencyService();

  void realChanged(String text) {
    if (text.isEmpty) {
      limparCampos();
      return;
    }

    double real = double.tryParse(text.replaceAll(",", ".")) ?? 0;

    dolarController.text = (real / dolar).toStringAsFixed(2);

    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void dolarChanged(String text) {
    if (text.isEmpty) {
      limparCampos();
      return;
    }

    double dolarValue = double.tryParse(text.replaceAll(",", ".")) ?? 0;

    realController.text = (dolarValue * dolar).toStringAsFixed(2);

    euroController.text = (dolarValue * dolar / euro).toStringAsFixed(2);
  }

  void euroChanged(String text) {
    if (text.isEmpty) {
      limparCampos();
      return;
    }

    double euroValue = double.tryParse(text.replaceAll(",", ".")) ?? 0;

    realController.text = (euroValue * euro).toStringAsFixed(2);

    dolarController.text = (euroValue * euro / dolar).toStringAsFixed(2);
  }

  void limparCampos() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
  }

  Widget campoTexto(
    String label,
    String prefix,
    IconData icon,
    TextEditingController controller,
    Function(String) funcao,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(
        fontSize: 22,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: funcao,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Cotação de Moedas"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: api.buscarCotacoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Erro ao carregar cotações",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];

          euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 90,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Conversor de Moedas",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Cotações atualizadas em tempo real",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                campoTexto(
                  "Reais",
                  "R\$ ",
                  Icons.currency_exchange,
                  realController,
                  realChanged,
                ),
                const SizedBox(height: 16),
                campoTexto(
                  "Dólares",
                  "US\$ ",
                  Icons.attach_money,
                  dolarController,
                  dolarChanged,
                ),
                const SizedBox(height: 16),
                campoTexto(
                  "Euros",
                  "€ ",
                  Icons.euro,
                  euroController,
                  euroChanged,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
