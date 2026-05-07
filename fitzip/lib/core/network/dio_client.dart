import 'package:dio/dio.dart';
import 'package:fitzip/core/constants/api_constants.dart';
import 'package:fitzip/core/network/auth_interceptor.dart';

Dio createDio(AuthInterceptor authInterceptor) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.addAll([
    authInterceptor,
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
}
