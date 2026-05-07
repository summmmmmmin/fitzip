import 'package:fitzip/features/auth/domain/entity/token.dart';

class TokenModel {
  final String accessToken;
  final String refreshToken;

  const TokenModel({required this.accessToken, required this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      );

  Token toEntity() => Token(accessToken: accessToken, refreshToken: refreshToken);
}
