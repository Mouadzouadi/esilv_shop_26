import 'package:esilv_shop/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/product.dart';

class DetailProductPage extends ConsumerWidget {
  final Product product;

  const DetailProductPage({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProducts = ref.watch(cartProvider);
    final isInCart = cartProducts.any((p) => p.id == product.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(product.title),
        actions: [
          IconButton(
            //push : empile le panier => le retour ramène à ce produit
            onPressed: () => context.push('/cart'),
            icon: Badge.count(
              count: cartProducts.length,
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
                //5 étoiles : jaunes jusqu'à la note arrondie (3.9 => 4)
                for (int i = 1; i <= 5; i++)
                  Icon(
                    Icons.star,
                    size: 20,
                    color: i <= product.rating.rate.round()
                        ? Colors.amber
                        : Colors.grey,
                  ),
                const SizedBox(width: 8),
                Text("${product.rating.rate}/5 (${product.rating.count})"),
              ],
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
          //Spacer : pousse le bouton tout en bas
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FilledButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).add(product);
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
