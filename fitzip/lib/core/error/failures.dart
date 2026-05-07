abstract class Failure {
  final String code;
  final String message;
  const Failure({required this.code, required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.code, required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super(code: 'NETWORK', message: '네트워크 연결을 확인해주세요.');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
      : super(code: 'A005', message: '로그인이 필요합니다.');
}

class UnknownFailure extends Failure {
  const UnknownFailure()
      : super(code: 'UNKNOWN', message: '알 수 없는 오류가 발생했습니다.');
}
