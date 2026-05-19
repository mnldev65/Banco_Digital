import 'package:flutter/material.dart';
import 'routes.dart'; 

void main() {
  runApp(const MeuBancoApp());
}

class MeuBancoApp extends StatelessWidget {
  const MeuBancoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco Digital',
      debugShowCheckedModeBanner: false,
      
      initialRoute: '/login', 
      
      routes: AppRotas.obterRotas(), 
    );
  }
}