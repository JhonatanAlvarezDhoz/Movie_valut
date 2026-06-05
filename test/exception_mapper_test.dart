import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/mapper/mapper_error.dart';

void main() {
  test(
    'ExceptionMapper maps controlled exceptions to user-facing failures',
    () {
      expect(ExceptionMapper.map(NetworkException()), isA<NetworkFailure>());
      expect(ExceptionMapper.map(ServerException()), isA<ServerFailure>());
      expect(ExceptionMapper.map(ParsingException()), isA<ServerFailure>());
      expect(
        ExceptionMapper.map(ValidationException()),
        isA<ValidationFailure>(),
      );
      expect(
        ExceptionMapper.map(UnauthorizedException()),
        isA<UnauthorizedFailure>(),
      );
      expect(ExceptionMapper.map(ConflictException()), isA<ConflictFailure>());
      expect(ExceptionMapper.map(CacheException()), isA<CacheFailure>());
    },
  );
}
