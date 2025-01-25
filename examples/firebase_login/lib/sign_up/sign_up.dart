import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../auth/auth_repository.dart';

part 'sign_up.freezed.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpProvider);

    ref.listen<SignUpState>(signUpProvider, (previous, next) {
      next.maybeWhen(
        success: () => Navigator.pop(context),
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SignUpForm(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Already have an account? Sign in'),
            ),
            state.maybeMap(
              failure: (failure) => Text(
                failure.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});
  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpProvider);
    final stateNotifier = ref.watch(signUpProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email address',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: state.isFormSubmitting
              ? null
              : () => stateNotifier.signUpWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
          child: state.isFormSubmitting
              ? const CircularProgressIndicator.adaptive()
              : const Text('Create your account'),
        ),
      ],
    );
  }
}

final signUpProvider = StateNotifierProvider<SignUpStateNotifier, SignUpState>(
  (ref) => SignUpStateNotifier(
    authRepository: ref.read<AuthRepository>(authRepositoryProvider),
  ),
);

@freezed
sealed class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;
  const factory SignUpState.loading() = _Loading;
  const factory SignUpState.success() = _Success;
  const factory SignUpState.failure(String message) = _Failure;
}

class SignUpStateNotifier extends StateNotifier<SignUpState> {
  SignUpStateNotifier({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const SignUpState.initial());

  final AuthRepository _authRepository;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const SignUpState.loading();
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const SignUpState.success();
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = SignUpState.failure(e.message);
    } catch (_) {
      state = const SignUpState.failure('An unexpected error occured!');
    }
  }
}

extension SignUpStateExtension on SignUpState {
  bool get isFormSubmitting {
    return switch (this) {
      SignUpState.loading => true,
      _ => false,
    };
  }
}
