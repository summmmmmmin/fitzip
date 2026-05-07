import 'package:dartz/dartz.dart';
import 'package:fitzip/core/error/failures.dart';
import 'package:fitzip/features/auth/domain/entity/token.dart';

abstract class AuthRepository {
  Future<Either<Failure, Token>> signUp({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String birthDate,
  });

  Future<Either<Failure, Token>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();
}
