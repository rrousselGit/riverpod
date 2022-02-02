import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // আমরা ডিফল্ট সর্ট টাইপ রিটার্ন দিই, এখানে নাম।
  (ref) => ProductSortType.name,
);
