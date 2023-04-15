# Pub

Install needed global packages

```bash
cd riverpod
dart pub global activate melos
```

Build the riverpod packages

```bash
flutter pub get
```

## Start the Example App

```bash
cd examples/pub
flutter pub run build_runner build


flutter create . --platforms android
flutter run
```
