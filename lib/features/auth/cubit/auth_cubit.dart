import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  StreamSubscription? _authSubscription;

  AuthCubit(this._repository) : super(const AuthUnauthenticated()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = _repository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      await _repository.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      emit(AuthError(_firebaseErrorMessage(e)));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      await _repository.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      emit(AuthError(_firebaseErrorMessage(e)));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());

    try {
      await _repository.signInWithGoogle();
    } catch (e) {
      emit(AuthError(_firebaseErrorMessage(e)));
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading());

    try {
      await _repository.signOut();
    } catch (e) {
      emit(AuthError(_firebaseErrorMessage(e)));
    }
  }

  String _firebaseErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('invalid-credential')) {
      return 'Invalid email or password.';
    }

    if (message.contains('email-already-in-use')) {
      return 'An account already exists with this email.';
    }

    if (message.contains('weak-password')) {
      return 'Password is too weak.';
    }

    if (message.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    }

    if (message.contains('user-not-found')) {
      return 'No account found with this email.';
    }

    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }

    return 'Something went wrong. Please try again.';
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}