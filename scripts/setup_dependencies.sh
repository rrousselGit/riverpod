BASEDIR=$(dirname "$0")

cd $BASEDIR/../packages/riverpod

echo "Installing riverpod"
dart pub get

cd ../flutter_riverpod

echo "overriding flutter_riverpod dependencies"
echo "
dependency_overrides:
  riverpod:
    path: ../../packages/riverpod" >> pubspec.yaml

echo "Installing flutter_riverpod"
flutter pub get

cd ../hooks_riverpod

echo "overriding hooks_riverpod dependencies"
echo "
dependency_overrides:
  flutter_riverpod:
    path: ../../packages/flutter_riverpod
  riverpod:
    path: ../../packages/riverpod" >> $BASEDIR/../packages/hooks_riverpod/pubspec.yaml

echo "Installing hooks_riverpod"
flutter pub get