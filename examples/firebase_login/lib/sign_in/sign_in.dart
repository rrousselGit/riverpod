import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../auth/auth_repository.dart';
import '../sign_up/sign_up.dart';

part 'sign_in.freezed.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInProvider);
    final stateNotifier = ref.watch(signInProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to your account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SignInForm(),
            ElevatedButton(
              onPressed: state.isFormSubmitting
                  ? null
                  : stateNotifier.signInWithGoogle,
              child: state.isFormSubmitting
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Sign in with google'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const SignUpPage(),
                ),
              ),
              child: const Text('Do not have an account? Register'),
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

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});
  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
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
    final state = ref.watch(signInProvider);
    final stateNotifier = ref.watch(signInProvider.notifier);

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
              : () => stateNotifier.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
          child: state.isFormSubmitting
              ? const CircularProgressIndicator.adaptive()
              : const Text('Sign in to your account'),
        ),
      ],
    );
  }
}

final signInProvider = StateNotifierProvider<SignInStateNotifier, SignInState>(
  (ref) => SignInStateNotifier(
    authRepository: ref.read<AuthRepository>(authRepositoryProvider),
  ),
);

@freezed
sealed class SignInState with _$SignInState {
  const factory SignInState.initial() = _Initial;
  const factory SignInState.loading() = _Loading;
  const factory SignInState.success() = _Success;
  const factory SignInState.failure(String message) = _Failure;
}

class SignInStateNotifier extends StateNotifier<SignInState> {
  SignInStateNotifier({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const SignInState.initial());

  final AuthRepository _authRepository;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const SignInState.loading();
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const SignInState.success();
    } on SignInWithEmailAndPasswordFailure catch (e) {
      state = SignInState.failure(e.message);
    } catch (_) {
      state = const SignInState.failure('An unexpected error occured!');
    }
  }

  Future<void> signInWithGoogle() async {
    state = const SignInState.loading();
    try {
      await _authRepository.signInWithGoogle();
      state = const SignInState.success();
    } on SignInWithGoogleFailure catch (e) {
      state = SignInState.failure(e.message);
    } catch (_) {
      state = const SignInState.failure('An unexpected error occured!');
    }
  }
}

extension SignInStateExtension on SignInState {
  bool get isFormSubmitting {
    return switch (this) {
      SignInState.loading => true,
      _ => false,
    };
  }
}
