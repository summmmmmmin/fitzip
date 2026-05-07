import 'package:dio/dio.dart';
import 'package:fitzip/core/constants/api_constants.dart';
import 'package:fitzip/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;

  AuthInterceptor(this._tokenStorage, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newTokens = await _refreshTokens();
        if (newTokens != null) {
          final retryOptions = err.requestOptions
            ..headers['Authorization'] = 'Bearer ${newTokens['accessToken']}';
          final response = await _dio.fetch(retryOptions);
          handler.resolve(response);
          return;
        }
      } catch (_) {
        await _tokenStorage.clearAll();
      }
    }
    handler.next(err);
  }

  Future<Map<String, dynamic>?> _refreshTokens() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return null;

    final response = await _dio.post(
      ApiConstants.refresh,
      options: Options(headers: {'X-Refresh-Token': refreshToken}),
    );

    final data = response.data['data'];
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
    return data;
  }
}
