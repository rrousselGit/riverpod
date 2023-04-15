import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // Devolvemos el tipo de clasificación predeterminado, aquí `name`.
  (ref) => ProductSortType.name,
);
