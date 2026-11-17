import 'package:esilv_shop/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

//Stateful : état local (carte choisie) + ref pour vider le panier
class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  //Moyens de paiement proposés (icônes Font Awesome)
  final List<FaIconData> paymentMethods = [
    FontAwesomeIcons.ccVisa,
    FontAwesomeIcons.ccMastercard,
    FontAwesomeIcons.ccAmex,
    FontAwesomeIcons.ccDinersClub,
    FontAwesomeIcons.ccDiscover,
    FontAwesomeIcons.ccJcb,
  ];

  //Index du moyen sélectionné (null = aucun)
  int? selectedIndex;

  //Clé du formulaire pour lancer la validation des champs
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Paiement'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Text(
                    "Sélectionner le moyen de paiement",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: paymentMethods.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          //setState : modifie l'état local et redessine la page
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : null,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: FaIcon(paymentMethods[index], size: 32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Informations de paiement",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.credit_card),
                      labelText: "Numéro de carte",
                      border: OutlineInputBorder(),
                    ),
                    validator: requiredField,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Nom du titulaire",
                      border: OutlineInputBorder(),
                    ),
                    validator: requiredField,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            labelText: "Date d'expiration (MM/AA)",
                            border: OutlineInputBorder(),
                          ),
                          validator: requiredField,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "CVV",
                            border: OutlineInputBorder(),
                          ),
                          validator: requiredField,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                  onPressed: confirmPayment,
                  child: const Text("Confirmer le paiement"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Validator commun : le champ ne doit pas être vide
  String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return "Champ obligatoire";
    }
    return null;
  }

  void confirmPayment() {
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sélectionnez un moyen de paiement")),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      ref.read(cartProvider.notifier).clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paiement confirmé, merci !")),
      );
      context.go('/');
    }
  }
}
