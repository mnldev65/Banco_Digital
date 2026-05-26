import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseServico {
  static Future<void> inicializar() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp();
      print("Firebase inicializado com sucesso!");
    } catch (e) {
      print("Erro ao inicializar o Firebase: $e");
    }
  }
}