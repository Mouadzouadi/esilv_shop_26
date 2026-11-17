import 'package:esilv_shop/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

class DetailProductPage extends StatelessWidget {
  final Product product;

  const DetailProductPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final isInCart =
        context.watch<Cart>().products.any((p) => p.id == product.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(product.title),
        actions: [
          IconButton(
            onPressed: () => context.go('/cart'),
            icon: Badge.count(
              count: context.watch<Cart>().products.length,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Container(
            color: Colors.black12,
            child: Image.network(
              product.image,
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(product.getPrice()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(product.description),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(product.category),
          ),
          if (isInCart)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                avatar: Icon(Icons.shopping_cart),
                label: Text("Produit déjà dans le panier"),
              ),
            ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FilledButton(
                onPressed: () {
                  context.read<Cart>().add(product);
                },
                child: const Text("Ajouter au panier"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
