## Work in progress

This project is a work-in-progress command that analyzes a Riverpod project and
generates a graph of the interactions between providers/widgets

## Example
Graphs can be generated using [d2](https://d2lang.com/) or [Mermaid](https://mermaid-js.github.io/mermaid/#/) text-to-graph syntax.

Here is graph example, generated from the Flutter Devtool project (which uses Riverpod).

![Devtool graph](../../resources/devtool_graph.jpeg)

## Generating a graph

Assuming you are working on `riverpod_graph` in this repo.  You can test against other projects with relative references. Generating a graph against the `examples/todos` project would look like:

```
cd <the riverpod_graph directory>
```

mermaid.js markup
```bash
dart run riverpod_graph path/to/folder
```

d2 markup
```bash
dart run riverpod_graph path/to/folder -f d2
```

Assuming you have activated, installed, riverpod_graph in the global dart cache:

mermaid.js markup
```bash
cd <the lib directory of the program you wish to analyze>
$ dart pub global run riverpod_graph .
```
________________________

## Example Todos mermaid.js graph

This graph was generated in mermaid format with _Provider Types_ enabled.

```mermaid

flowchart TB
  subgraph Arrows
    direction LR
    start1[ ] -..->|read| stop1[ ]
    style start1 height:0px;
    style stop1 height:0px;
    start2[ ] --->|listen| stop2[ ]
    style start2 height:0px;
    style stop2 height:0px;
    start3[ ] ===>|watch| stop3[ ]
    style start3 height:0px;
    style stop3 height:0px;
  end

  subgraph Type
    direction TB
    ConsumerWidget((widget));
    Provider[[provider]];
  end
  filteredTodos[["filteredTodos</br>Provider&lt; List&lt; Todo &gt; &gt;"]];
  todoListProvider[["todoListProvider</br>StateNotifierProvider&lt; TodoList, List&lt; Todo &gt; &gt;"]];
  todoListFilter[["todoListFilter</br>StateProvider&lt; TodoListFilter &gt;"]];
  uncompletedTodosCount[["uncompletedTodosCount</br>Provider&lt; int &gt;"]];
  _currentTodo[["_currentTodo</br>Provider&lt; Todo &gt;"]];
  Home((Home));
  filteredTodos ==> Home;
  todoListProvider -.-> Home;
  todoListProvider -.-> Home;
  Toolbar((Toolbar));
  todoListFilter ==> Toolbar;
  uncompletedTodosCount ==> Toolbar;
  todoListFilter -.-> Toolbar;
  todoListFilter -.-> Toolbar;
  todoListFilter -.-> Toolbar;
  TodoItem((TodoItem));
  _currentTodo ==> TodoItem;
  todoListProvider -.-> TodoItem;
  todoListProvider -.-> TodoItem;
  todoListFilter ==> filteredTodos;
  todoListProvider ==> filteredTodos;
  todoListProvider ==> uncompletedTodosCount;

  ```


## Example with containing classes from a test case
_A work in progress_

  ```mermaid
  flowchart TB
  subgraph Arrows
    direction LR
    start1[ ] -..->|read| stop1[ ]
    style start1 height:0px;
    style stop1 height:0px;
    start2[ ] --->|listen| stop2[ ]
    style start2 height:0px;
    style stop2 height:0px;
    start3[ ] ===>|watch| stop3[ ]
    style start3 height:0px;
    style stop3 height:0px;
  end
  subgraph Type
    direction TB
    ConsumerWidget((widget));
    Provider[[provider]];
  end
  additionProvider[["additionProvider</br>FutureProvider&lt; num&gt;"]];
  normalProvider[["normalProvider</br>Provider&lt; int&gt;"]];
  futureProvider[["futureProvider</br>FutureProvider&lt; int&gt;"]];
  familyProviders[["familyProviders</br>ProviderFamily&lt; int, Object?&gt;"]];
  functionProvider[["functionProvider</br>Provider&lt; int Function()&gt;"]];
  selectedProvider[["selectedProvider</br>Provider&lt; int&gt;"]];
  subgraph SampleClass
    SampleClass.normalProvider[["normalProvider</br>Provider&lt; int&gt;"]];
  end
  subgraph SampleClass
    SampleClass.futureProvider[["futureProvider</br>FutureProvider&lt; int&gt;"]];
  end
  subgraph SampleClass
    SampleClass.familyProviders[["familyProviders</br>ProviderFamily&lt; int, Object?&gt;"]];
  end
  subgraph SampleClass
    SampleClass.functionProvider[["functionProvider</br>Provider&lt; int Function()&gt;"]];
  end
  subgraph SampleClass
    SampleClass.selectedProvider[["selectedProvider</br>Provider&lt; int&gt;"]];
  end
  normalProvider ==> additionProvider;
  futureProvider ==> additionProvider;
  familyProviders ==> additionProvider;
  functionProvider ==> additionProvider;
  selectedProvider ==> additionProvider;
  SampleClass.normalProvider ==> additionProvider;
  SampleClass.futureProvider ==> additionProvider;
  SampleClass.familyProviders ==> additionProvider;
  SampleClass.functionProvider ==> additionProvider;
  SampleClass.selectedProvider ==> additionProvider;
  ```