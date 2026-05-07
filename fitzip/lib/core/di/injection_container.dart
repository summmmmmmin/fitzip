import 'package:dio/dio.dart';
import 'package:fitzip/core/network/auth_interceptor.dart';
import 'package:fitzip/core/network/dio_client.dart';
import 'package:fitzip/core/storage/token_storage.dart';
import 'package:fitzip/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:fitzip/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fitzip/features/auth/domain/repository/auth_repository.dart';
import 'package:fitzip/features/bmi/data/datasource/bmi_remote_datasource.dart';
import 'package:fitzip/features/bmi/data/repository/bmi_repository_impl.dart';
import 'package:fitzip/features/bmi/domain/repository/bmi_repository.dart';
import 'package:fitzip/features/analysis/data/datasource/analysis_remote_datasource.dart';
import 'package:fitzip/features/analysis/data/repository/analysis_repository_impl.dart';
import 'package:fitzip/features/analysis/domain/repository/analysis_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Storage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => TokenStorage(sl()));

  // Network
  final tokenStorage = sl<TokenStorage>();
  final baseDio = Dio();
  final authInterceptor = AuthInterceptor(tokenStorage, baseDio);
  sl.registerLazySingleton(() => authInterceptor);
  sl.registerLazySingleton(() => createDio(sl()));

  // Datasources
  sl.registerLazySingleton(() => AuthRemoteDatasource(sl()));
  sl.registerLazySingleton(() => BmiRemoteDatasource(sl()));
  sl.registerLazySingleton(() => AnalysisRemoteDatasource(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<BmiRepository>(() => BmiRepositoryImpl(sl()));
  sl.registerLazySingleton<AnalysisRepository>(() => AnalysisRepositoryImpl(sl()));
}
