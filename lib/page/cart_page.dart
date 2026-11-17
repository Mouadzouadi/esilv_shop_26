import 'package:esilv_shop/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final totalPrice = cart.products.fold<num>(0, (sum, p) => sum + p.price);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Panier'),
      ),
      body: cart.products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Votre panier est vide"),
                  SizedBox(height: 8),
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Votre panier total est de",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${totalPrice.toStringAsFixed(2)}€",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.products.length,
                    itemBuilder: (context, index) {
                      final product = cart.products[index];
                      return ListTile(
                        leading: Image.network(product.image, width: 50),
                        title: Text(product.title, maxLines: 1),
                        subtitle: Text(product.getPrice()),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            context.read<Cart>().remove(product);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
