import 'package:flutter/material.dart';
import '../servicos/api_servico.dart';

class Cotacao extends StatefulWidget {
  const Cotacao({super.key});

  @override
  State<Cotacao> createState() => _CotacaoState();
}

class _CotacaoState extends State<Cotacao> {

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

    double real =
        double.tryParse(text.replaceAll(",", ".")) ?? 0;

    dolarController.text =
        (real / dolar).toStringAsFixed(2);

    euroController.text =
        (real / euro).toStringAsFixed(2);
  }

  void dolarChanged(String text) {

    if (text.isEmpty) {
      limparCampos();
      return;
    }

    double dolarValue =
        double.tryParse(text.replaceAll(",", ".")) ?? 0;

    realController.text =
        (dolarValue * dolar).toStringAsFixed(2);

    euroController.text =
        (dolarValue * dolar / euro).toStringAsFixed(2);
  }

  void euroChanged(String text) {

    if (text.isEmpty) {
      limparCampos();
      return;
    }

    double euroValue =
        double.tryParse(text.replaceAll(",", ".")) ?? 0;

    realController.text =
        (euroValue * euro).toStringAsFixed(2);

    dolarController.text =
        (euroValue * euro / dolar).toStringAsFixed(2);
  }

  void limparCampos() {

    realController.clear();
    dolarController.clear();
    euroController.clear();
  }

  Widget campoTexto(
    String label,
    String prefix,
    TextEditingController controller,
    Function(String) funcao,
  ) {

    return TextField(

      controller: controller,

      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),

      style: const TextStyle(
        fontSize: 24,
      ),

      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefix,
      ),

      onChanged: funcao,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Cotação de Moedas"),
        centerTitle: true,
      ),

      body: FutureBuilder<Map<String, dynamic>>(

        future: api.buscarCotacoes(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return const Center(
              child: Text("Erro ao carregar cotações"),
            );
          }

          dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];

          euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

          return SingleChildScrollView(

            padding: const EdgeInsets.all(16),

            child: Column(

              children: [

                const Icon(
                  Icons.attach_money,
                  size: 120,
                ),

                const SizedBox(height: 20),

                campoTexto(
                  "Reais",
                  "R\$ ",
                  realController,
                  realChanged,
                ),

                const SizedBox(height: 16),

                campoTexto(
                  "Dólares",
                  "US\$ ",
                  dolarController,
                  dolarChanged,
                ),

                const SizedBox(height: 16),

                campoTexto(
                  "Euros",
                  "€ ",
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