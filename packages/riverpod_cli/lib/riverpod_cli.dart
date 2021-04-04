import 'package:args/command_runner.dart';
import 'package:riverpod_cli/src/migrate.dart';

class RiverpodCommand extends CommandRunner<void> {
  RiverpodCommand() : super('riverpod', '') {
    addCommand(MigrateCommand());
  }
}
