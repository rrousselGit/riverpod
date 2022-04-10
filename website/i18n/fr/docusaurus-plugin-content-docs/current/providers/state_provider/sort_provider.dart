import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';

/* DÉBUT DU SNIPPET */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // On retourne le type de tri par défaut, ici nom.
  (ref) => ProductSortType.name,
);
