// import 'package:collection/collection.dart';
// // ignore: implementation_imports
// import 'package:riverpod/src/internals.dart';

// /// An internal class for `ProviderBase.select`.
// class ProviderSelector<Input, Output> implements ProviderListenable<Output> {
//   /// An internal class for `ProviderBase.select`.
//   ProviderSelector(
//     this.provider,
//     this._selector,
//   );

//   /// The selected provider
//   final ProviderBase<ProviderDependencyBase, Input> provider;
//   final Output Function(Input) _selector;

//   @override
//   ProviderSubscription addLazyListener(
//     ProviderContainer container, {
//     void Function() mayHaveChanged,
//     void Function(Output value) onChange,
//   }) {
//     final state = container.readProviderState(provider);
//     return SelectorSubscription._(
//       state,
//       _selector,
//       mayHaveChanged,
//       onChange,
//     );
//   }
// }

// /// A [ProviderSubscription] for `ProviderBase.select`, that calls `onChange`
// /// only when the value computed changes.
// class SelectorSubscription<Input, Output> implements ProviderSubscription {
//   SelectorSubscription._(
//     ProviderStateBase<ProviderDependencyBase, Input,
//             ProviderBase<ProviderDependencyBase, Input>>
//         providerState,
//     this._selector,
//     void Function() mayHaveChanged,
//     this._onOutputChange,
//   ) {
//     _providerSubscription = providerState.addLazyListener(
//       mayHaveChanged: mayHaveChanged,
//       onChange: _onInputChange,
//     );
//   }

//   ProviderSubscription _providerSubscription;
//   final void Function(Output value) _onOutputChange;
//   bool _isFirstInputOnChange = true;
//   Input _input;
//   Output _lastOutput;
//   Output Function(Input) _selector;

//   /// Change the selector and immediatly call `onChange` with the new value.
//   void updateSelector(ProviderListenable subscription) {
//     _selector = (subscription as ProviderSelector<Input, Output>)._selector;
//     _providerSubscription.flush();
//     _onOutputChange(_lastOutput = _selector(_input));
//   }

//   void _onInputChange(Input input) {
//     _input = input;
//     if (_isFirstInputOnChange) {
//       _isFirstInputOnChange = false;
//       _onOutputChange(_lastOutput = _selector(_input));
//     }
//   }

//   @override
//   bool flush() {
//     if (_providerSubscription.flush()) {
//       final newOutput = _selector(_input);
//       if (!const DeepCollectionEquality().equals(_lastOutput, newOutput)) {
//         _onOutputChange(_lastOutput = newOutput);
//         return true;
//       }
//     }
//     return false;
//   }

//   @override
//   void close() => _providerSubscription.close();
// }
