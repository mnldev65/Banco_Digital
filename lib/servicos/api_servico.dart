import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {

  final String apiKey = "01069670";

  Future<Map<String, dynamic>> buscarCotacoes() async {

    final url = Uri.parse(
      'https://api.hgbrasil.com/finance?format=json&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Erro ao buscar moedas");
    }
  }
}