// core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'İnternet bağlantısı yoxdur']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server xətası baş verdi']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Sorğu vaxtı bitdi']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Yaddaşda saxlama xətası']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Naməlum xəta baş verdi']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
