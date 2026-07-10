// features/compare/data/repositories/compare_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:crypto_portfolio_tracker/core/errors/failures.dart';
import '../../domain/entities/compare_result.dart';
import '../../domain/repositories/compare_repository.dart';
import '../datasources/compare_remote_datasource.dart';

class CompareRepositoryImpl implements CompareRepository {
  final CompareRemoteDataSource remoteDataSource;

  CompareRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CompareResult>> compareCoins({
    required String firstCoinId,
    required String secondCoinId,
    required String days,
    String vsCurrency = 'usd',
  }) async {
    try {
      final results = await Future.wait([
        remoteDataSource.getCoinCompareData(
          coinId: firstCoinId,
          days: days,
          vsCurrency: vsCurrency,
        ),
        remoteDataSource.getCoinCompareData(
          coinId: secondCoinId,
          days: days,
          vsCurrency: vsCurrency,
        ),
      ]);

      return Right(CompareResult(first: results[0], second: results[1]));
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.data is Map && e.response?.data['error'] != null) {
        errorMessage = e.response!.data['error'].toString();
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(TimeoutFailure());
      } else if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      } else {
        errorMessage = e.message ?? 'Server error occurred';
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
