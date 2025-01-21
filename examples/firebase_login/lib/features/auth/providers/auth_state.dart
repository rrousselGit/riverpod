import 'dart:async';

import 'package:firebase_login/features/auth/data/models/user.dart';
import 'package:firebase_login/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unauthenticated()) {
    _userStreamSubscription?.cancel();
    _userStreamSubscription = _authRepository.user.listen((user) {
      state = user.isUnuthenticated
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(user);
    });
  }

  final AuthRepository _authRepository;
  StreamSubscription<User>? _userStreamSubscription;

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  @override
  void dispose() {
    _userStreamSubscription?.cancel();
    super.dispose();
  }
}
