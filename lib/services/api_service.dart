// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/card_model.dart'; // Importación actualizada de 'card_model.dart'

class ApiService {
  static const String _baseUrl = "https://db.ygoprodeck.com/api/v7/cardinfo.php";
  
  Future<List<CardModel>> fetchCards() async {
    final response = await http.get(Uri.parse("$_baseUrl?level=8&attribute=dark&sort=atk"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((card) => CardModel.fromJson(card)).toList();
    } else {
      throw Exception("Failed to load cards");
    }
  }
}