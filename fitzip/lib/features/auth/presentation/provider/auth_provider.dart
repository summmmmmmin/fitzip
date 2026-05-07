import 'package:dartz/dartz.dart';
import 'package:fitzip/core/di/injection_container.dart';
import 'package:fitzip/core/error/failures.dart';
import 'package:fitzip/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;

  const AuthState({this.isLoading = false, this.isAuthenticated = false});

  AuthState copyWith({bool? isLoading, bool? isAuthenticated}) => AuthState(
        isLoading: isLoading ?? this.isLoading,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.login(email: email, password: password);
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: result.isRight(),
    );
    return result;
  }

  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String birthDate,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.signUp(
      name: name, email: email, password: password,
      gender: gender, birthDate: birthDate,
    );
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: result.isRight(),
    );
    return result;
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(sl<AuthRepository>()),
);
