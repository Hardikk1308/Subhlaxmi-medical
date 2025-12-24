import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/orders/domain/repositories/orders_repository.dart';

class InsertOrderUseCase implements UseCase<String, Map<String, dynamic>> {
  final OrdersRepository repository;

  InsertOrderUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) async {
    return await repository.insertOrder(params);
  }
}
