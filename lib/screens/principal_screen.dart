import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:login_bueno_randy/screens/favorite_screen.dart';
import 'package:login_bueno_randy/screens/login_screen.dart';
import 'package:login_bueno_randy/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/api_service.dart';
import '/models/card_model.dart';
import 'package:login_bueno_randy/detail_page.dart';

class PrincipalScreen extends StatefulWidget {
  final String token;

  // Recibe el token JWT desde la pantalla anterior o el login
  PrincipalScreen({required this.token});

  @override
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  late Future<List<CardModel>> _cardList;
  late String userEmail;
  List<String> _favoriteCards = [];
  List<CardModel> _cards = []; // Nueva variable para almacenar las cartas
  List<CardModel> _filteredCards = []; // Lista para las cartas filtradas
  bool _isSearching = false; // Controla si está en modo búsqueda o no
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Decodificamos el token JWT y extraemos el email
    final jwt = JWT.decode(widget.token);
    userEmail = jwt.payload['email'];

    _cardList = ApiService().fetchCards(); // Llamamos al servicio de la API

    // Cargar las cartas favoritas del usuario
    _loadFavorites();
  }

  // Método para cargar las cartas favoritas desde SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteCards = prefs.getStringList(userEmail) ?? []; // Cargar favoritos usando el correo como clave
    });
  }

  // Método para agregar o quitar una carta de favoritos
  void _toggleFavorite(String cardName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteCards.contains(cardName)) {
        _favoriteCards.remove(cardName);
      } else {
        _favoriteCards.add(cardName);
      }
      // Guardamos los favoritos actualizados en SharedPreferences
      prefs.setStringList(userEmail, _favoriteCards);
    });
  }

  // Filtra las cartas según el término de búsqueda
  void _filterCards(String query) {
    final filteredCards = _cards.where((card) {
      final cardNameLower = card.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return cardNameLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredCards = filteredCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? Text("Yu-Gi-Oh Cards", textAlign: TextAlign.center) // Centra el título
            : TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar cartas...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onChanged: (query) {
                  _filterCards(query);
                },
              ),
        centerTitle: true, // Centrar el título en el AppBar
        actions: [
          !_isSearching
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _filteredCards = _cards;
                    });
                  },
                ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('$userEmail'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoritos'),
              onTap: () async {
                // Navegar a la pantalla de favoritos
                final updateFavorites = await Navigator.pushReplacement(
 context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteScreen(
                      userEmail: userEmail, // Pasa el email del usuario
                      favoriteCards: List<String>.from(_favoriteCards), // Pasa la lista de cartas favoritas
                      token: widget.token, // Pasa el token
                    ),
                  ),
                );
                if (updateFavorites != null) {
                  setState(() {
                    _favoriteCards = List<String>.from(updateFavorites);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () async {
                // Cerrar sesión utilizando el AuthServices
                await AuthServices().logout(); // Limpia token y SharedPreferences
                
                // Navegar de vuelta a la pantalla de login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false, // Elimina todas las rutas previas
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<CardModel>>(
        future: _cardList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No cards found"));
          }

          _cards = snapshot.data!;
          _filteredCards = _filteredCards.isNotEmpty ? _filteredCards : _cards;

          return ListView.builder(
            itemCount: _filteredCards.length,
            itemBuilder: (context, index) {
              final card = _filteredCards[index];
              final isFavorite = _favoriteCards.contains(card.name);
              Color _textColor = Colors.black; // Color de texto predeterminado

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return ListTile(
                    leading: Image.network(
                      card.imageUrl,
                    ),
                    title: Text(
                      card.name,
                      style: TextStyle(
                        fontSize: 21, // Tamaño del texto
                        fontWeight: FontWeight.bold,
                        color: _textColor = Colors.black, // Color del texto
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        _toggleFavorite(card.name);
                      },
                    ),
                    onTap: () {
                      // Cambiar el color del texto al hacer clic en la carta
                      setState(() {
                        _textColor = _textColor == Colors.black ? Colors.blue : Colors.black;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(card: card),
                        ),
                      );
                    },
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