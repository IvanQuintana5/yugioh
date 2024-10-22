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
      body: SingleChildScrollView( // Envolver todo el contenido en un scroll
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(card.imageUrl),
              SizedBox(height: 16),
              Text(
                card.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Tipo: ${card.typeline.join(", ")}"),
              Text("Atributo: ${card.attribute}"),
              Text("ATK: ${card.atk} DEF: ${card.def}"),
              Text("Nivel: ${card.level}"),
              SizedBox(height: 16),
              Text(
                "Descripción:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(card.desc),
            ],
          ),
        ),
      ),
    );
  }
}
