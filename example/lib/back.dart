import 'package:flutter/widgets.dart';
import 'package:provider_hooks/provider_hooks.dart';
import 'package:state_notifier/state_notifier.dart';

final provider = Provider((_) => 42);

void main() {
  final stateOwner = ProviderStateOwner();

  provider.consume(stateOwner, (state) {
    state.value;
  });
}

class ProviderStateOwner {
  ProviderStateOwner fork(List<ProviderOverride> overrides) {}

  void dispose() {}
}

extension<Res> on Provider<Res> {
  void consume(
    ProviderStateOwner stateOwner,
    void Function(ProviderListenerState<ProviderValue<Res>>) listener,
  ) {


  }
}

class Scope extends StatefulWidget {
  @override
  _ScopeState createState() => _ScopeState();
}

class _ScopeState extends State<Scope> {
  ProviderStateOwner ancestorState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ScopeInherited extends InheritedWidget {
  const _ScopeInherited({
    Key key,
    this.someState,
    Widget child,
  }) : super(key: key, child: child);

  final ProviderStateOwner someState;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
