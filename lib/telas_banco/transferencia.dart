import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Transferencia extends StatefulWidget {
  const Transferencia({super.key});

  @override
  State<Transferencia> createState() => _TransferenciaState();
}

class _TransferenciaState extends State<Transferencia> {
  final _formKey = GlobalKey<FormState>();
  final _destinatarioController = TextEditingController();
  final _valorController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _destinatarioController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _realizarTransferencia() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      await Supabase.instance.client.from('transferencias').insert({
        'usuario_id': uid,
        'destinatario': _destinatarioController.text.trim(),
        'valor': double.parse(_valorController.text.replaceAll(',', '.')),
        'data': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Transferência para ${_destinatarioController.text.trim()} realizada!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      _destinatarioController.clear();
      _valorController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Erro ao realizar transferência. Tente novamente.'),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } finally {
      if (mounted) setState(() => _carregando = false);
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
                    Icon(Icons.account_balance_wallet,
                        size: 60, color: Colors.green[700]),
                    const SizedBox(height: 10),
                    Text(
                      'Realize sua transferência',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
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
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe o nome do destinatário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _valorController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe um valor';
                  final parsed =
                      double.tryParse(v.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Informe um valor válido maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _carregando ? null : _realizarTransferencia,
                icon: _carregando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Icon(Icons.send, color: Colors.white),
                label: Text(
                  _carregando ? 'Enviando...' : 'Enviar Transferência',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
