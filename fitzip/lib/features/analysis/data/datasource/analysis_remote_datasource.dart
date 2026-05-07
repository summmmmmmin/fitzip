import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fitzip/core/constants/api_constants.dart';

class AnalysisRemoteDatasource {
  final Dio _dio;
  AnalysisRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> analyze(File imageFile) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });
    final response = await _dio.post(
      ApiConstants.analysis,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getResult(String id) async {
    final response = await _dio.get('${ApiConstants.analysis}/$id');
    return response.data['data'];
  }
}
