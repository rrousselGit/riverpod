import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// StateNotifier'ımızın durumu değişmez (immutable) olmalıdır.
// Uygulamada yardımcı olması için Freezed gibi paketler de kullanabiliriz.
@immutable
class Todo {
  const Todo(
      {required this.id, required this.description, required this.completed});

  // Sınıfımızdaki tüm özellikler `final` olmalıdır.
  final String id;
  final String description;
  final bool completed;

  // `Todo` değişmez olduğundan, içeriği biraz farklı olan
  // bir `Todo` kopyası oluşturan bir yöntem uyguluyoruz.
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// StateNotifierProvider'ımıza geçirilecek StateNotifier sınıfı.
// Bu sınıf, durumunu "state" özelliği dışında açmamalıdır,
// yani getterlar/kamuya açık özellikler yok!
class TodosNotifier extends StateNotifier<List<Todo>> {
  // `todos` listesini boş bir liste olarak başlatıyoruz.
  TodosNotifier() : super([]);

  // Kullanıcı arayüzünün todo eklemesine izin verelim.
  void addTodo(Todo todo) {
    // Durumumuz değişmez olduğundan, `state.add(todo)` yapamayız.
    // Bunun yerine, önceki elemanları ve yenisini içeren yeni bir
    // todos listesi oluşturmalıyız.
    // Burada Dart'ın spread operatörünü kullanmak faydalıdır!
    state = [...state, todo];
    // "notifyListeners" veya benzeri bir şeyi çağırmaya gerek yoktur.
    // "state =" çağırmak, gerektiğinde kullanıcı arayüzünü otomatik olarak yeniden oluşturacaktır.
  }

  // `todos` silmemize izin verelim
  void removeTodo(String todoId) {
    // Yine, durumumuz değişmez. Bu yüzden mevcut listeyi değiştirmek yerine yeni bir
    // liste oluşturuyoruz.
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // Bir `todo`yu tamamlandı olarak işaretleyelim
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // Sadece eşleşen `todo`yu tamamlandı olarak işaretliyoruz
        if (todo.id == todoId)
          // Yine, durumumuz değişmez olduğundan, bir kopya yapmamız gerekiyor.
          // Bize yardımcı olması için daha önce uyguladığımız `copyWith` yöntemini kullanıyoruz.
          todo.copyWith(completed: !todo.completed)
        else
          // diğer `todos` değiştirilmez
          todo,
    ];
  }
}

// Son olarak, kullanıcı arayüzünün TodosNotifier sınıfımızla etkileşimde bulunmasını
// sağlamak için StateNotifierProvider kullanıyoruz.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
