import 'package:esilv_shop/model/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart.g.dart';

//@riverpod : build_runner génère cartProvider dans cart.g.dart
@riverpod
class Cart extends _$Cart {
  //État initial : panier vide
  @override
  List<Product> build() {
    return [];
  }

  //On remplace state par une NOUVELLE liste => Riverpod prévient les widgets
  void add(Product product) {
    state = [...state, product];
  }

  //Retire un seul exemplaire du produit (la 1re occurrence)
  void remove(Product product) {
    final newState = [...state];
    newState.remove(product);
    state = newState;
  }

  //Vide le panier (après le paiement)
  void clear() {
    state = [];
  }

  //Somme des prix en centimes (fold), puis conversion en euros
  String get priceInEuros =>
      "${(state.fold(0, (prv, actual) => prv + actual.price) / 100).toStringAsFixed(2)}€";
}