import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  //ProviderScope : conserve l'état de tous les providers Riverpod (obligatoire)
  runApp(const ProviderScope(
    child: EsilvShop(),
  ));
}
