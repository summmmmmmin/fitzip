import 'package:dio/dio.dart';
import 'package:fitzip/core/constants/api_constants.dart';
import 'package:fitzip/features/auth/data/model/token_model.dart';

class AuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasource(this._dio);

  Future<TokenModel> signUp({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String birthDate,
  }) async {
    final response = await _dio.post(ApiConstants.signUp, data: {
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'birthDate': birthDate,
    });
    return TokenModel.fromJson(response.data['data']);
  }

  Future<TokenModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(ApiConstants.login, data: {
      'email': email,
      'password': password,
    });
    return TokenModel.fromJson(response.data['data']);
  }

  Future<void> logout() async {
    await _dio.post(ApiConstants.logout);
  }
}
