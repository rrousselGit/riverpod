# Pub

Install needed global packages

```bash
cd riverpod
dart pub global activate melos
```

Build the riverpod packages

```bash
melos bootstrap --ignore "codemod_riverpod_*,riverpod_cli" 
```

## Start the Example App

```bash
cd examples/pub
flutter pub run build_runner build


flutter create . --platforms android
flutter run
```
