import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'todo.dart';

final addTodoKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

final todoListProvider = StateNotifierProvider((ref) {
  return TodoList([
    Todo(id: 'todo-0', description: 'hi'),
    Todo(id: 'todo-1', description: 'hello'),
    Todo(id: 'todo-2', description: 'bonjour'),
  ]);
});

enum TodoListFilter {
  all,
  active,
  completed,
}

final todoListFilter =
    ChangeNotifierProvider((_) => ValueNotifier(TodoListFilter.all));

final uncompletedTodosCount = Computed((read) {
  return read(todoListProvider.state).where((todo) => !todo.completed).length;
});

final filteredTodos = Computed((read) {
  final filter = read(todoListFilter);
  final todos = read(todoListProvider.state);

  switch (filter.value) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
    default:
      return todos;
  }
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final owner = ProviderStateOwnerScope.of(context);
    // final state = owner.debugProviderStates.firstWhere((p) {
    //   return p.provider == filteredTodos;
    // });

    // state.flush();

    final todos = useProvider(filteredTodos);
    final newTodoController = useTextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            const Title(),
            TextField(
              key: addTodoKey,
              controller: newTodoController,
              decoration: const InputDecoration(
                labelText: 'What needs to be done?',
              ),
              onSubmitted: (value) {
                todoListProvider.read(context).add(value);
                newTodoController.clear();
              },
            ),
            const SizedBox(height: 42),
            Column(
              children: [
                const Toolbar(),
                if (todos.isNotEmpty) const Divider(height: 0),
                for (var i = 0; i < todos.length; i++) ...[
                  if (i > 0) const Divider(height: 0),
                  Dismissible(
                    key: ValueKey(todos[i].id),
                    onDismissed: (_) {
                      todoListProvider.read(context).remove(todos[i]);
                    },
                    child: TodoItem(todos[i]),
                  )
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Toolbar extends HookWidget {
  const Toolbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = useProvider(todoListFilter);

    Color textColorFor(TodoListFilter value) {
      return filter.value == value ? Colors.blue : null;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${useProvider(uncompletedTodosCount).toString()} items left',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            key: allFilterKey,
            message: 'All todos',
            child: FlatButton(
              onPressed: () => filter.value = TodoListFilter.all,
              visualDensity: VisualDensity.compact,
              textColor: textColorFor(TodoListFilter.all),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            key: activeFilterKey,
            message: 'Only uncompleted todos',
            child: FlatButton(
              onPressed: () => filter.value = TodoListFilter.active,
              visualDensity: VisualDensity.compact,
              textColor: textColorFor(TodoListFilter.active),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            key: completedFilterKey,
            message: 'Only completed todos',
            child: FlatButton(
              onPressed: () => filter.value = TodoListFilter.completed,
              visualDensity: VisualDensity.compact,
              textColor: textColorFor(TodoListFilter.completed),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

class TodoItem extends HookWidget {
  const TodoItem(this.todo, {Key key}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final itemFocusNode = useFocusNode();
    // listen to focus chances
    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Semantics(
      child: Material(
        color: Colors.white,
        elevation: 6,
        child: Focus(
          focusNode: itemFocusNode,
          onFocusChange: (focused) {
            if (focused) {
              textEditingController.text = todo.description;
            }
          },
          child: ListTile(
            onTap: () {
              itemFocusNode.requestFocus();
              textFieldFocusNode.requestFocus();
            },
            leading: Checkbox(
              value: todo.completed,
              onChanged: (value) =>
                  todoListProvider.read(context).toggle(todo.id),
            ),
            title: isFocused
                ? TextField(
                    autofocus: true,
                    focusNode: textFieldFocusNode,
                    controller: textEditingController,
                    onEditingComplete: itemFocusNode.unfocus,
                    onSubmitted: (value) {
                      todoListProvider
                          .read(context)
                          .edit(id: todo.id, description: value);
                    },
                  )
                : Text(todo.description),
          ),
        ),
      ),
    );
  }
}
