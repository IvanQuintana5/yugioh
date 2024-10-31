import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:login_bueno_randy/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/card_model.dart';
import '/services/api_service.dart';
import 'principal_screen.dart';
import 'login_screen.dart'; // Asegúrate de importar tu pantalla de inicio de sesión

class FavoriteScreen extends StatefulWidget {
  final String userEmail;
  final List<String> favoriteCards;
  final String token;

  FavoriteScreen(
      {required this.userEmail,
      required this.favoriteCards,
      required this.token});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<CardModel>> _favoriteCardDetailsFuture;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    final jwt = JWT.decode(widget.token);
    userEmail = jwt.payload['email'];
    _favoriteCardDetailsFuture = _loadFavoriteCardDetails();
  }

  Future<List<CardModel>> _loadFavoriteCardDetails() async {
    List<CardModel> cards = await ApiService().fetchCards();
    return cards
        .where((card) => widget.favoriteCards.contains(card.name))
        .toList();
  }

  void _removeFavorite(String cardName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.favoriteCards.remove(cardName);
      _favoriteCardDetailsFuture = _loadFavoriteCardDetails();
      prefs.setStringList(widget.userEmail, widget.favoriteCards);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$cardName ha sido eliminado de favoritos.')),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Eliminamos el token del almacenamiento

    // Redirigimos al usuario a la pantalla de inicio de sesión
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
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
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrincipalScreen(token: widget.token),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: _logout, // Llama a la función _logout cuando se presiona
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<CardModel>>(
        future: _favoriteCardDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay cartas favoritas aún."));
          }

          final favoriteCardDetails = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteCardDetails.length,
            itemBuilder: (context, index) {
              final card = favoriteCardDetails[index];
              return ListTile(
                leading: Image.network(card.imageUrl),
                title: Text(
                  card.name,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    _removeFavorite(card.name);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(card: card)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}