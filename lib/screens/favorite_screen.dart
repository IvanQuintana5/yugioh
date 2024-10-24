import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart'; // Asegúrate de importar esta librería
import 'package:login_bueno_randy/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/card_model.dart';
import '/services/api_service.dart'; // Servicio para obtener las cartas (si es necesario)
import 'principal_screen.dart'; // Asegúrate de importar PrincipalScreen

class FavoriteScreen extends StatefulWidget {
  final String userEmail;
  final List<String> favoriteCards;
  final String token; // Agregar el token

  FavoriteScreen({required this.userEmail, required this.favoriteCards, required this.token});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<CardModel> _favoriteCardDetails = [];
  late String userEmail; // Variable para almacenar el correo del usuario

  @override
  void initState() {
    super.initState();
    // Decodificamos el token JWT y extraemos el email
    final jwt = JWT.decode(widget.token);
    userEmail = jwt.payload['email'];

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

    // Mostrar un snackbar que indique que se ha eliminado
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$cardName ha sido eliminado de favoritos.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartas Favoritas'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Pantalla Principal'),
              onTap: () {
                // Navegar a la pantalla principal
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrincipalScreen(token: widget.token), // Pasar el token
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _favoriteCardDetails.isEmpty
          ? Center(child: Text('No hay cartas favoritas aún.'))
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