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

  PrincipalScreen({required this.token});

  @override
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  late Future<List<CardModel>> _cardList;
  late String userEmail;
  List<String> _favoriteCards = [];
  List<CardModel> _cards = [];
  List<CardModel> _filteredCards = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final jwt = JWT.decode(widget.token);
    userEmail = jwt.payload['email'];
    _cardList = ApiService().fetchCards();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteCards = prefs.getStringList(userEmail) ?? [];
    });
  }

  void _toggleFavorite(String cardName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteCards.contains(cardName)) {
        _favoriteCards.remove(cardName);
      } else {
        _favoriteCards.add(cardName);
      }
      prefs.setStringList(userEmail, _favoriteCards);
    });
  }

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
            ? Text("Yu-Gi-Oh Cards", textAlign: TextAlign.center)
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
        centerTitle: true,
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
                color: const Color.fromARGB(255, 243, 33, 33),
              ),
              child: Text('$userEmail',style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoritos'),
              onTap: () async {
                final updateFavorites = await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteScreen(
                      userEmail: userEmail,
                      favoriteCards: List<String>.from(_favoriteCards),
                      token: widget.token,
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
                await AuthServices().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/fp.png',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<CardModel>>(
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
              _filteredCards =
                  _filteredCards.isNotEmpty ? _filteredCards : _cards;

              return ListView.builder(
                itemCount: _filteredCards.length,
                itemBuilder: (context, index) {
                  final card = _filteredCards[index];
                  final isFavorite = _favoriteCards.contains(card.name);

                  return ListTile(
                    leading: Image.network(card.imageUrl),
                    title: Text(
                      card.name,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        _toggleFavorite(card.name);
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
              );
            },
          ),
        ],
      ),
    );
  }
}