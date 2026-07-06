// core/errors/failures.dart
import 'package:equatable/equatable.dart';

/// Bütün domain-level xətaların əsası.
/// Repository-lər həmişə `Either<Failure, T>` qaytarır (dartz).
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// İnternet yoxdur və ya bağlantı kəsildi
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'İnternet bağlantısı yoxdur']);
}

/// API 4xx/5xx qaytardı
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server xətası baş verdi']);
}

/// Sorğu vaxtı bitdi
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Sorğu vaxtı bitdi']);
}

/// Local storage (GetStorage) ilə bağlı xəta
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Yaddaşda saxlama xətası']);
}

/// Gözlənilməz/naməlum xəta
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Naməlum xəta baş verdi']);
}

/// İstifadəçi girişi ilə bağlı xəta (məs: mənfi miqdar, boş sahə)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
