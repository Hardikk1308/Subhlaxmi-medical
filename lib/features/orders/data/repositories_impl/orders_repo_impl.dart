import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/orders/data/data_sources/order_remote_data_source.dart'
    hide ServerException;
import 'package:mediecom/features/orders/domain/entities/order_details_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_history_entity.dart';
import 'package:mediecom/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OrderEntity>>> fetchOrderList(
    String userId,
  ) async {
    try {
      final orders = await remoteDataSource.fetchOrderList(userId);
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while fetching orders',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OrderDetailsEntity>> fetchOrderDetails(
    String orderId,
  ) async {
    try {
      final details = await remoteDataSource.fetchOrderDetails(orderId);
      return Right(details);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while fetching order details',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<OrderHistoryEntity>>> fetchOrderHistory(
    String orderId,
  ) async {
    try {
      final history = await remoteDataSource.fetchOrderHistory(orderId);
      return Right(history);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while fetching order history',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      await remoteDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while updating order status',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> insertOrder(
    Map<String, dynamic> orderData,
  ) async {
    try {
      appLog('Inserting order with data: $orderData');
      final orderId = await remoteDataSource.insertOrder(orderData);
      return Right(orderId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while inserting order',
          statusCode: 500,
        ),
      );
    }
  }
}
