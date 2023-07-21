# Pub

## Install needed global packages

```bash
cd riverpod
dart pub global activate melos
```

## Build the Example App

Run the code generation
```bash
cd examples/pub
flutter pub get
dart run build_runner build -d
```

## Run the Example App

Create and run the android deployable
```bash
flutter create . --platforms android
flutter run
```
