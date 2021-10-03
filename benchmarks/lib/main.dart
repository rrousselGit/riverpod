import 'add_listener.dart' as add_listener;
import 'create_bench.dart' as create;
import 'read_bench.dart' as read;
import 'remove_listener.dart' as remove_listener;

void main() {
  create.main();
  read.main();
  remove_listener.main();
  add_listener.main();
}
