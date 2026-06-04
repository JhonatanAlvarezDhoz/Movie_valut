import 'package:movie_valut/core/errors/exceptions/exceptions.dart';

class ApiResponseEnvelope {
  final int? statusCode;
  final String? message;
  final bool isSuccess;
  final dynamic data;

  const ApiResponseEnvelope({
    required this.isSuccess,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ApiResponseEnvelope.fromJson(Map<String, dynamic> json) {
    return ApiResponseEnvelope(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      isSuccess: json['isSuccess'] as bool? ?? false,
      data: json['data'],
    );
  }

  void ensureSuccess(String fallbackMessage) {
    if (!isSuccess) {
      throw ServerException(message ?? fallbackMessage);
    }
  }

  Map<String, dynamic> requireMapData(String fallbackMessage) {
    ensureSuccess(fallbackMessage);

    if (data is Map<String, dynamic>) {
      return data as Map<String, dynamic>;
    }

    throw ParsingException('Respuesta inesperada del servidor.');
  }
}
