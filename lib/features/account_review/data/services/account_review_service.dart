import 'package:mediecom/features/account_review/data/models/company_model.dart';

class AccountReviewService {
  /// Check if the company data indicates account is under review
  static bool isAccountUnderReview(CompanyModel? company) {
    if (company == null) return false;
    
    final description = company.coDes1?.toLowerCase() ?? '';
    return description.contains('under review') || 
           description.contains('under reivew'); // Handle typo from API
  }

  /// Get the logo URL from company data
  static String? getLogoUrl(CompanyModel company) {
    // Try to get logo from CO_PER1 first, then fallback to other logo fields
    return company.coPer1 ?? company.coPer2 ?? company.coPer3 ?? company.coPer4;
  }

  /// Get contact number from company data
  static String getContactNumber(CompanyModel company) {
    return company.coTel1 ?? company.coTel ?? '7000980233';
  }

  /// Parse company data from API response
  static CompanyModel? parseCompanyFromResponse(Map<String, dynamic> response) {
    try {
      if (response['response'] == 'success' && response['data'] != null) {
        final dataList = response['data'] as List;
        if (dataList.isNotEmpty) {
          return CompanyModel.fromJson(dataList[0]);
        }
      }
    } catch (e) {
      print('Error parsing company data: $e');
    }
    return null;
  }
}
