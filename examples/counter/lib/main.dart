import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navProv = StateNotifierProvider<ItemNav, String>((ref) {
  return ItemNav();
});

class ItemNav extends StateNotifier<String> {
  ItemNav() : super('');

  void viewItem({String? item, bool pageActive: true}) {
    if (pageActive) {
      state = item!;
    } else
      state = '';
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: home(),
      ),
    );
  }
}

class home extends ConsumerWidget {
  const home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(navProv.notifier).viewItem(item: 'Item for Remi');
            Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => EditItem()),
            );
          },
          child: Text('Navigate to item'),
        ),
      ),
    );
  }
}

class EditItem extends ConsumerWidget {
  const EditItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vMstate = ref.watch(viewModelProv);
    bool saving = vMstate == 1 ? true : false;
    final item = ref.watch(viewModelProv.notifier).item;
    return Scaffold(
      appBar: AppBar(title: Text('Showing item')),
      body: saving
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text(item)),
                ElevatedButton(
                    onPressed: () {
                      ref
                          .read(viewModelProv.notifier)
                          .updateItem('Update some properties');
                    },
                    child: Text('Update'))
              ],
            ),
    );
  }
}

final viewModelProv = StateNotifierProvider.autoDispose<ViewModel, int>((ref) {
  final navState = ref.watch(navProv);

  final notifier = ref.watch(navProv.notifier);
  final item = navState.toString();
  print('create viwmodelprov');
  ref.onDispose(() {
    print("disposing viewModelPro\n${StackTrace.current}");
    //ref.watch(navProv.notifier).viewItem(pageActive: false);
    notifier.viewItem(pageActive: false);
  });

  return ViewModel(ref.read, item);
});

class ViewModel extends StateNotifier<int> {
  final Reader _read;
  final String _item;
  String get item => _item;

  ViewModel(this._read, this._item) : super(0);

  Future<void> updateItem(String update) async {
    state = 1;
    // DO Database stuff
    await Future<void>.delayed(Duration(seconds: 5));
    state = 0;
  }
}
