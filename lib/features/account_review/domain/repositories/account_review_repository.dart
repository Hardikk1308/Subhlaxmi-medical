import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/account_review/data/models/company_model.dart';

abstract class AccountReviewRepository {
  Future<Either<Failure, CompanyModel>> checkAccountStatus(String userId);
}
