import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaTransferencia extends StatefulWidget {
  const TelaTransferencia({super.key});

  @override
  State<TelaTransferencia> createState() => _TelaTransferenciaState();
}

class _TelaTransferenciaState extends State<TelaTransferencia> {
  final _formKey = GlobalKey<FormState>();

  final _destinatarioController = TextEditingController();
  final _valorController = TextEditingController();

  Future<void> _realizarTransferencia() async {
    if (_formKey.currentState!.validate()) {
      String destinatario = _destinatarioController.text;

      double valor = double.parse(_valorController.text);

      try {
        await FirebaseFirestore.instance.collection('transferencias').add({
          'destinatario': destinatario,
          'valor': valor,
          'data': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Transferência para $destinatario realizada com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        _destinatarioController.clear();
        _valorController.clear();
      } catch (erro) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar transferência: $erro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Nova Transferência'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                      Icons.account_balance_wallet,
                      size: 60,
                      color: Colors.green[700],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Realize sua transferência',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _destinatarioController,
                decoration: InputDecoration(
                  labelText: 'Nome do Destinatário',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do destinatário';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }

                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Insira um valor válido maior que zero';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _realizarTransferencia,
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Enviar Transferência',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
