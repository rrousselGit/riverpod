**Work in progress**

This project is a work-in-progress command that analyzes a Riverpod project and
generates a graph of the interactions between providers/widgets

The graph generated is generated using [Mermaid](https://mermaid-js.github.io/mermaid/#/)

Here is graph example, generated from the Flutter Devtool project (which uses Riverpod).

![Devtool graph](../../resources/devtool_graph.jpeg)

## Generating a graph

Assuming you are working on `riverpod_graph` in this repo.  You can test against other projects with relative references. Generating a graph against the `examples/todos` project would look like:

```
cd into the riverpod_graph directory
../riverpod/packages/riverpod_graph$ dart run riverpod_graph:riverpod_graph ../../examples/todos/lib -f d2
```

Assuming you have activated, installed, riverpod_graph in the dart cache:

```
cd into the lib directory of the program you wish to analyze
dart run riverpod_graph:riverpod_graph <path-to-root-dir> -f d2
```
