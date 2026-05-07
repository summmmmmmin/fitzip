import 'package:dio/dio.dart';
import 'package:fitzip/core/constants/api_constants.dart';

class BmiRemoteDatasource {
  final Dio _dio;
  BmiRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> calculate({
    required double heightCm,
    required double weightKg,
  }) async {
    final response = await _dio.post(ApiConstants.bmi, data: {
      'heightCm': heightCm,
      'weightKg': weightKg,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getLatest() async {
    final response = await _dio.get(ApiConstants.bmiLatest);
    return response.data['data'];
  }
}
