import 'package:flutter_riverpod/legacy.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // Devolvemos el tipo de clasificación predeterminado, aquí `name`.
  (ref) => ProductSortType.name,
);
