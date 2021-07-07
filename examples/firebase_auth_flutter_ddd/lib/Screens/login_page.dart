import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_flutter_ddd/Screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Application/Authentication/auth_events.dart';
import '../Application/Authentication/auth_state_controller.dart';
import '../Application/Authentication/auth_states.dart';
import '../Services/Authentication/firebase_auth_facade.dart';
import 'Utils/custom_snackbar.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<AuthStateController, AuthStates>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseAuthFacade = FirebaseAuthFacade(firebaseAuth);
  return AuthStateController(firebaseAuthFacade);
});

class LoginPage extends HookConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formStates = ref.watch(loginProvider);
    final formEvents = ref.watch(loginProvider.notifier);
    ref.listen<AuthStates>(loginProvider, (value) {
      value.authFailureOrSuccess.fold(
        () {},
        (either) => either.fold(
          (failure) {
            buildCustomSnackBar(
                context: context,
                flashBackground: Colors.red,
                icon: Icons.warning_rounded,
                content: Text(
                  failure.maybeMap(
                      orElse: () => '',
                      emailAlreadyInUse: (value) => 'User already exists',
                      serverError: (value) {
                        return 'Server error occurred';
                      },
                      invalidEmailAndPasswordCombination: (value) {
                        return 'Invalid email or password';
                      }),
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ));
          },
          (success) {
            buildCustomSnackBar(
                context: context,
                flashBackground: Colors.green,
                icon: CupertinoIcons.check_mark_circled_solid,
                content: Text(
                  'Login successful',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ));
            Navigator.push<Widget>(context, MaterialPageRoute(builder: (context) => HomePage(),));
          },
        ),
      );
    });
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: SizedBox.expand(
            child: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome !', style: Theme.of(context).textTheme.headline2,),
                      const SizedBox(height: 50,),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) => formEvents.mapEventsToStates(
                            AuthEvents.emailChanged(email: value.toString())),
                        validator: (value) =>
                            formStates.emailAddress.valueObject!.fold(
                          (failure) => failure.maybeMap(
                              orElse: () => null,
                              invalidEmail: (value) => 'Invalid email'),
                          (r) => null,
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validator: (value) =>
                            formStates.password.valueObject!.fold(
                          (failure) => failure.maybeMap(
                            orElse: () => null,
                            shortPassword: (value) => 'Very short password',
                            noUpperCase: (value) =>
                                'Must contain an uppercase character',
                            noNumber: (value) => 'Must contain a number',
                            noSpecialSymbol: (value) =>
                                'Must contain a special character',
                          ),
                          (r) => null,
                        ),
                        onChanged: (value) => formEvents.mapEventsToStates(
                          AuthEvents.passwordChanged(
                              password: value.toString()),
                        ),
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.headline6),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formEvents.mapEventsToStates(
                                      const AuthEvents
                                          .signInWithEmailAndPasswordPressed(),
                                    );
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.headline6),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formEvents.mapEventsToStates(
                                      const AuthEvents
                                          .signUpWithEmailAndPasswordPressed(),
                                    );
                                  }
                                },
                                child: const Text('Sign Up'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if(formStates.isSubmitting)
                        ...[
                          const SizedBox(height: 20,),
                          const LinearProgressIndicator(
                            minHeight: 6,
                          )
                        ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
