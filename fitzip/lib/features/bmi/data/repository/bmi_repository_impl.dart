import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitzip/core/error/failures.dart';
import 'package:fitzip/features/bmi/data/datasource/bmi_remote_datasource.dart';
import 'package:fitzip/features/bmi/domain/entity/bmi_result.dart';
import 'package:fitzip/features/bmi/domain/repository/bmi_repository.dart';

class BmiRepositoryImpl implements BmiRepository {
  final BmiRemoteDatasource _datasource;
  BmiRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, BmiResult>> calculate({
    required double heightCm,
    required double weightKg,
  }) async {
    try {
      final data = await _datasource.calculate(heightCm: heightCm, weightKg: weightKg);
      return Right(_fromJson(data));
    } on DioException catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, BmiResult>> getLatest() async {
    try {
      final data = await _datasource.getLatest();
      return Right(_fromJson(data));
    } on DioException catch (e) {
      return Left(_mapError(e));
    }
  }

  BmiResult _fromJson(Map<String, dynamic> d) => BmiResult(
        heightCm: (d['heightCm'] as num).toDouble(),
        weightKg: (d['weightKg'] as num).toDouble(),
        bmi: (d['bmi'] as num).toDouble(),
        bmiCategory: d['bmiCategory'] as String,
        bmiCategoryLabel: d['bmiCategoryLabel'] as String,
        age: d['age'] as int,
        idealWeightKg: (d['idealWeightKg'] as num).toDouble(),
        weightDiffKg: (d['weightDiffKg'] as num).toDouble(),
        weightAdvice: d['weightAdvice'] as String,
      );

  Failure _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError) return const NetworkFailure();
    final err = e.response?.data?['error'];
    if (err != null) return ServerFailure(code: err['code'], message: err['message']);
    return const UnknownFailure();
  }
}
