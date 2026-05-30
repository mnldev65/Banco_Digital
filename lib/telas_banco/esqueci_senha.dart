import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EsqueciSenhaTela extends StatefulWidget {
  const EsqueciSenhaTela({super.key});

  @override
  State<EsqueciSenhaTela> createState() => _EsqueciSenhaTelaState();
}

class _EsqueciSenhaTelaState extends State<EsqueciSenhaTela> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _carregando = false;
  bool _emailEnviado = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _snackErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _enviarRecuperacao() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
      );
      if (mounted) setState(() => _emailEnviado = true);
    } on AuthException catch (e) {
      if (mounted) {
        _snackErro(e.message.contains('Too many requests')
            ? 'Muitas tentativas. Aguarde alguns minutos.'
            : 'Erro ao enviar e-mail. Tente novamente.');
      }
    } catch (_) {
      if (mounted) _snackErro('Erro inesperado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        title: const Text('Recuperar Senha'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _emailEnviado ? _buildSucesso() : _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_reset, size: 72, color: Colors.blue[800]),
          const SizedBox(height: 20),
          Text(
            'Esqueceu sua senha?',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800]),
          ),
          const SizedBox(height: 12),
          Text(
            'Informe seu e-mail cadastrado e enviaremos um link para redefinir sua senha.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 36),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'E-mail cadastrado',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
              if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(v.trim())) {
                return 'E-mail inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _carregando ? null : _enviarRecuperacao,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _carregando
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Text('Enviar link de recuperação',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Voltar ao login',
                style: TextStyle(color: Colors.blue[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildSucesso() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.mark_email_read, size: 80, color: Colors.green[600]),
        const SizedBox(height: 24),
        Text(
          'E-mail enviado!',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800]),
        ),
        const SizedBox(height: 12),
        Text(
          'Verifique a caixa de entrada de ${_emailController.text.trim()} e clique no link para redefinir sua senha.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(height: 6),
        Text(
          'Não esqueça de checar a pasta de spam.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        const SizedBox(height: 36),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Voltar ao Login',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() {
            _emailEnviado = false;
            _emailController.clear();
          }),
          child: Text('Tentar outro e-mail',
              style: TextStyle(color: Colors.blue[700])),
        ),
      ],
    );
  }
}
