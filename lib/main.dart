import 'package:flutter/material.dart';
import 'package:login_bueno_randy/detail_page.dart';
//import 'package:login_bueno_randy/screens/principal_screen.dart';
import 'package:provider/provider.dart';
import 'package:login_bueno_randy/screens/checking_screen.dart';
import 'package:login_bueno_randy/screens/login_screen.dart';
import 'package:login_bueno_randy/screens/registro_screen.dart';
import 'package:login_bueno_randy/services/auth_services.dart';
import 'package:login_bueno_randy/services/notifications_services.dart';
import 'services/api_service.dart';
import 'models/card_model.dart';

void main() {
  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServices()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login and Yu-Gi-Oh Cards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 2247, 230, 196)),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'checking', // Cambiar el estado inicial según autenticación
      routes: {
        'login': (_) => LoginScreen(), // Pantalla de login
        'register': (_) => RegistroScreen(), // Pantalla de registro
        // La nueva página principal con cartas Yu-Gi-Oh
        'checking': (_) => CheckAuthScreen(), // Verificación de autenticación
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<CardModel>> _cardList;

  @override
  void initState() {
    super.initState();
    _cardList = ApiService()
        .fetchCards(); // Llamamos al servicio para las cartas Yu-Gi-Oh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yu-Gi-Oh Cards"),
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

          final cards = snapshot.data!;

          return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return ListTile(
                leading: Image.network(card.imageUrl),
                title: Text(card.name),
                onTap: () {
                  // Navegar a la pantalla de detalles
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
    );
  }
}