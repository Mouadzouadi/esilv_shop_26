import 'package:esilv_shop/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch => la page se reconstruit à chaque ajout / retrait
    final cartProducts = ref.watch(cartProvider);
    //Le getter lit le state à jour du Cart
    final totalPrice = ref.read(cartProvider.notifier).priceInEuros;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Panier Esilv Shop'),
      ),
      body: Column(
        children: [
          //Prix total en haut du panier
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Votre panier total est de"),
                Text(
                  totalPrice,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          //Contenu du panier en dessous
          Expanded(
            child: cartProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Votre panier est vide"),
                        Icon(Icons.shopping_cart_outlined),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      leading: Image.network(
                        cartProducts[index].image,
                        width: 80,
                      ),
                      title: Text(cartProducts[index].title, maxLines: 2),
                      subtitle: Text(
                        cartProducts[index].getPrice(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .remove(cartProducts[index]);
                        },
                        child: Text("Retirer".toUpperCase()),
                      ),
                    ),
                  ),
          ),
          //Bouton Commander en bas (désactivé si panier vide)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FilledButton(
                onPressed: cartProducts.isEmpty
                    ? null
                    : () => context.go('/cart/payment'),
                child: const Text("Commander"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
