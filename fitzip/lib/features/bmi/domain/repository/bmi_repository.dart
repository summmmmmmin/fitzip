import 'package:dartz/dartz.dart';
import 'package:fitzip/core/error/failures.dart';
import 'package:fitzip/features/bmi/domain/entity/bmi_result.dart';

abstract class BmiRepository {
  Future<Either<Failure, BmiResult>> calculate({
    required double heightCm,
    required double weightKg,
  });

  Future<Either<Failure, BmiResult>> getLatest();
}
