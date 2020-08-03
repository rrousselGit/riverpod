BASEDIR=$(dirname "$0")

cd $BASEDIR/../packages/riverpod
dart test
cd ../flutter_riverpod
flutter test --no-pub
cd ../hooks_riverpod
flutter test --no-pub