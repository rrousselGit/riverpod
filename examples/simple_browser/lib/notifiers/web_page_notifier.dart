import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../resources/strings_manager.dart';

class WebPageNotifier extends StateNotifier<String> {
  WebPageNotifier() : super(AppStrings.initialPage);

  void setWebPage(String webPage) {
    state = webPage;
  }

}