class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://10.0.2.2:80'; // 에뮬레이터용 (실기기는 서버 IP로 변경)
  static const String apiPrefix = '/api/v1';

  // Auth
  static const String signUp = '$apiPrefix/auth/sign-up';
  static const String login = '$apiPrefix/auth/login';
  static const String refresh = '$apiPrefix/auth/refresh';
  static const String logout = '$apiPrefix/auth/logout';

  // BMI
  static const String bmi = '$apiPrefix/bmi';
  static const String bmiLatest = '$apiPrefix/bmi/latest';
  static const String bmiHistory = '$apiPrefix/bmi/history';

  // Analysis
  static const String analysis = '$apiPrefix/analysis';
  static const String analysisHistory = '$apiPrefix/analysis/history';
}
