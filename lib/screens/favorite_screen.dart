 import 'package:flutter/material.dart';
import 'package:login_bueno_randy/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/card_model.dart';
import '/services/api_service.dart'; // Servicio para obtener las cartas (si es necesario)

class FavoriteScreen extends StatefulWidget {
  final String userEmail;
  final List<String> favoriteCards;

  FavoriteScreen({required this.userEmail, required this.favoriteCards});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<CardModel> _favoriteCardDetails = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCardDetails(); // Cargamos la información detallada de las cartas favoritas
  }

  // Cargar la información de las cartas favoritas
  Future<void> _loadFavoriteCardDetails() async {
    List<CardModel> cards = await ApiService().fetchCards(); // Supongamos que tienes un servicio que obtiene todas las cartas

    setState(() {
      _favoriteCardDetails = cards
          .where((card) => widget.favoriteCards.contains(card.name))
          .toList(); // Filtra solo las cartas que están en favoritos
    });
  }

  // Eliminar una carta de favoritos
  void _removeFavorite(String cardName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.favoriteCards.remove(cardName);
      _favoriteCardDetails.removeWhere((card) => card.name == cardName);
      prefs.setStringList(widget.userEmail, widget.favoriteCards); // Actualizamos las preferencias
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartas Favoritas'),
      ),
      body: _favoriteCardDetails.isEmpty
          ? Center(child: Text('No hay cartas favoritas aun.'))
          : ListView.builder(
              itemCount: _favoriteCardDetails.length,
              itemBuilder: (context, index) {
                final card = _favoriteCardDetails[index];

                return ListTile(
                  leading: Image.network(card.imageUrl),
                  title: Text(
                    card.name,
                    style: TextStyle(
                      fontSize: 21, // Tamaño del texto
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite, // Botón para eliminar de favoritos
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _removeFavorite(card.name); // Elimina la carta de favoritos
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(card: card),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}