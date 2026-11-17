import 'package:esilv_shop/model/rating.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String image;
  //Prix stocké en centimes (109.95€ => 10995)
  final int price;
  final Rating rating;

  //Constructeur avec les paramètres nommés "required"
  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
  });
  String getPrice() => "${(price / 100).toStringAsFixed(2)}€";

  //Deux produits sont égaux s'ils ont le même id (utilisé par remove() du panier)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  //Sérialisation : objet -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'category': this.category,
      'image': this.image,
      //On renvoie le prix en euros, comme l'API
      'price': this.price / 100,
      'rating': this.rating.toMap(),
    };
  }

  //Désérialisation : Map (JSON décodé) -> objet
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      //L'API renvoie des euros (109.95) => on convertit en centimes
      price: ((map['price'] as num) * 100).round(),
      //Objet imbriqué : on délègue la conversion à Rating.fromMap
      rating: Rating.fromMap(map['rating'] as Map<String, dynamic>),
    );
  }
}
