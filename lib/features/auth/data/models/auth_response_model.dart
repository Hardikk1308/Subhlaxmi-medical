import 'package:mediecom/features/account_review/data/models/company_model.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';

class AuthResponseModel {
  final UserModel user;
  final CompanyModel? company;

  AuthResponseModel({
    required this.user,
    this.company,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    UserModel user = UserModel.fromJson(json['user'][0] ?? {});
    CompanyModel? company;

    if (json['company'] != null && (json['company'] as List).isNotEmpty) {
      company = CompanyModel.fromJson(json['company'][0]);
    }

    return AuthResponseModel(user: user, company: company);
  }
}
