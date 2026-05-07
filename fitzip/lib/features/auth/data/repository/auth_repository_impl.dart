import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitzip/core/error/failures.dart';
import 'package:fitzip/core/storage/token_storage.dart';
import 'package:fitzip/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:fitzip/features/auth/domain/entity/token.dart';
import 'package:fitzip/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._datasource, this._tokenStorage);

  @override
  Future<Either<Failure, Token>> signUp({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String birthDate,
  }) async {
    try {
      final model = await _datasource.signUp(
        name: name, email: email, password: password,
        gender: gender, birthDate: birthDate,
      );
      final token = model.toEntity();
      await _tokenStorage.saveTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );
      return Right(token);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  @override
  Future<Either<Failure, Token>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _datasource.login(email: email, password: password);
      final token = model.toEntity();
      await _tokenStorage.saveTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );
      return Right(token);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _datasource.logout();
      await _tokenStorage.clearAll();
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError) return const NetworkFailure();
    final data = e.response?.data;
    if (data != null && data['error'] != null) {
      return ServerFailure(
        code: data['error']['code'] ?? 'UNKNOWN',
        message: data['error']['message'] ?? '오류가 발생했습니다.',
      );
    }
    return const UnknownFailure();
  }
}
