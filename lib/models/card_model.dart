// lib/models/card_model.dart
class CardModel {
  final int id;
  final String name;
  final List<String> typeline;
  final String desc;
  final int atk;
  final int def;
  final int level;
  final String attribute;
  final String imageUrl;

  CardModel({
    required this.id,
    required this.name,
    required this.typeline,
    required this.desc,
    required this.atk,
    required this.def,
    required this.level,
    required this.attribute,
    required this.imageUrl,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      name: json['name'],
      typeline: List<String>.from(json['typeline']),
      desc: json['desc'],
      atk: json['atk'],
      def: json['def'],
      level: json['level'],
      attribute: json['attribute'],
      imageUrl: json['card_images'][0]['image_url'],
    );
  }
}
