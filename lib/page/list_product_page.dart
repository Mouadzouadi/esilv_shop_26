import 'dart:convert';

import 'package:esilv_shop/model/cart.dart';
import 'package:esilv_shop/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

class ListProductPage extends ConsumerWidget {
  const ListProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch : la page se reconstruit quand le panier change (badge)
    final cartProducts = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Boutique'),
        actions: [
          IconButton(
            onPressed: () => context.go('/cart'),
            icon: Badge.count(
              count: cartProducts.length,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      //Affiche la liste quand les produits sont arrivés, sinon un loader
      body: FutureBuilder(
        future: fetchProducts(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
            final products = asyncSnapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                onTap: () => context.go('/product/${products[index].id}'),
                title: Text(products[index].title, maxLines: 1),
                subtitle: Text(
                  products[index].getPrice(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Image.network(products[index].image, width: 80),
                trailing: TextButton(
                  onPressed: () {
                    //read : on appelle une action, sans s'abonner
                    ref.read(cartProvider.notifier).add(products[index]);
                  },
                  child: Text("Ajouter".toUpperCase()),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  //GET sur l'API, puis chaque Map JSON est convertie en Product
  Future<List<Product>> fetchProducts() async {
    final response = await get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      return products
          .map((product) => Product.fromMap(product as Map<String, dynamic>))
          .toList();
    }
    return Future.error("Erreur de connexion");
  }
}
