import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitzip/core/error/failures.dart';
import 'package:fitzip/features/analysis/data/datasource/analysis_remote_datasource.dart';
import 'package:fitzip/features/analysis/domain/entity/analysis_result.dart';
import 'package:fitzip/features/analysis/domain/repository/analysis_repository.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDatasource _datasource;
  AnalysisRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, AnalysisResult>> analyze(File imageFile) async {
    try {
      final data = await _datasource.analyze(imageFile);
      return Right(_fromJson(data));
    } on DioException catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, AnalysisResult>> getResult(String analysisId) async {
    try {
      final data = await _datasource.getResult(analysisId);
      return Right(_fromJson(data));
    } on DioException catch (e) {
      return Left(_mapError(e));
    }
  }

  AnalysisResult _fromJson(Map<String, dynamic> d) {
    final recs = (d['recommendations'] as List? ?? [])
        .map((r) => RecommendationItem(
              category: r['category'] as String,
              itemName: r['itemName'] as String,
              reason: r['reason'] as String,
              avoidItems: r['avoidItems'] as String?,
              imageUrl: r['imageUrl'] as String?,
            ))
        .toList();

    return AnalysisResult(
      id: d['id'].toString(),
      status: d['status'] as String,
      bodyType: d['bodyType'] as String?,
      bodyTypeLabel: d['bodyTypeLabel'] as String?,
      bodyTypeDescription: d['bodyTypeDescription'] as String?,
      confidenceScore: (d['confidenceScore'] as num?)?.toDouble(),
      recommendations: recs,
    );
  }

  Failure _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError) return const NetworkFailure();
    final err = e.response?.data?['error'];
    if (err != null) return ServerFailure(code: err['code'], message: err['message']);
    return const UnknownFailure();
  }
}
