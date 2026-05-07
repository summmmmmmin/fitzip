import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fitzip/core/error/failures.dart';
import 'package:fitzip/features/analysis/domain/entity/analysis_result.dart';

abstract class AnalysisRepository {
  Future<Either<Failure, AnalysisResult>> analyze(File imageFile);
  Future<Either<Failure, AnalysisResult>> getResult(String analysisId);
}
