import 'package:flutter/material.dart';
import '../models/card_model.dart'; // Ruta relativa a la carpeta 'models'

class DetailPage extends StatelessWidget {
  final CardModel card;

  DetailPage({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
      ),
      backgroundColor: Colors.black, // Fondo negro para la pantalla
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(card.imageUrl),
              SizedBox(height: 16),
              Text(
                card.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color blanco para el texto
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Tipo: ${card.typeline.join(", ")}",
                style: TextStyle(color: Colors.white), // Color blanco para el texto
              ),
              Text(
                "Atributo: ${card.attribute}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "ATK: ${card.atk} DEF: ${card.def}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Nivel: ${card.level}",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "Descripción:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                card.desc,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}