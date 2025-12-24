import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/app/cache_helper.dart';

/// ------------------------- MODEL -------------------------
class ApplicationModel {
  final String id;
  final String name;
  final String address1;
  final String? address2;
  final String? address3;
  final String? address4;
  final String? logo;
  final String? email;
  final String? contactNumber;
  final String? gstNumber;
  final String? bankName;
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? city;
  final String? c0Per31;
  final String? c0Per32;
  final String? c0Per33;

  ApplicationModel({
    required this.id,
    required this.name,
    required this.address1,
    this.address2,
    this.address3,
    this.address4,
    this.logo,
    this.email,
    this.contactNumber,
    this.gstNumber,
    this.bankName,
    this.bankAccountNumber,
    this.ifscCode,
    this.city,
    this.c0Per31,
    this.c0Per32,
    this.c0Per33,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['CO_Id'] ?? '',
      name: json['CO_NAME'] ?? '',
      address1: json['CO_ADD1'] ?? '',
      address2: json['CO_ADD2'],
      address3: json['CO_ADD3'],
      address4: json['CO_ADD4'],
      logo: json['CO_PER1'],
      email: json['CO_EMAIL'],
      contactNumber: json['CO_TEL'] ?? json['CO_TEL1'],
      gstNumber: json['CO_CST'],
      bankName: json['CO_PER6'],
      bankAccountNumber: json['CO_PER7'],
      ifscCode: json['CO_PER8'],
      city: json['CO_PER9'],
      c0Per31: json['CO_PER31'],
      c0Per32: json['CO_PER32'],
      c0Per33: json['CO_PER33'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CO_Id': id,
      'CO_NAME': name,
      'CO_ADD1': address1,
      'CO_ADD2': address2,
      'CO_ADD3': address3,
      'CO_ADD4': address4,
      'CO_PER1': logo,
      'CO_EMAIL': email,
      'CO_TEL': contactNumber,
      'CO_CST': gstNumber,
      'CO_PER6': bankName,
      'CO_PER7': bankAccountNumber,
      'CO_PER8': ifscCode,
      'CO_PER9': city,
      'CO_PER31': c0Per31,
      'CO_PER32': c0Per32,
      'CO_PER33': c0Per33,
    };
  }
}

/// ------------------------- RESPONSE WRAPPER -------------------------
class CompanyResponse {
  final String response;
  final List<ApplicationModel> data;

  CompanyResponse({required this.response, required this.data});

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    final list =
        (json['data'] as List<dynamic>?)
            ?.map((e) => ApplicationModel.fromJson(e))
            .toList() ??
        [];
    return CompanyResponse(response: json['response'] ?? '', data: list);
  }
}

/// ------------------------- SINGLETON REPOSITORY -------------------------
class ApplicationRepository {
  ApplicationRepository._privateConstructor();
  static final ApplicationRepository _instance =
      ApplicationRepository._privateConstructor();
  factory ApplicationRepository() => _instance;

  final String _apiUrl =
      'https://www.subhlaxmimedical.com/myadmin/Api/application';

  ApplicationModel? _cachedModel;
  CacheHelper? _cacheHelper;

  /// Initialize with CacheHelper instance
  void setCacheHelper(CacheHelper cacheHelper) {
    _cacheHelper = cacheHelper;
  }

  /// Call this once at app startup
  Future<void> initialize() async {
    if (_cacheHelper == null) {
      debugPrint('CacheHelper not set! Call setCacheHelper() first.');
      return;
    }

    // Try get cached data first
    _cachedModel = _cacheHelper!.getApplicationData();
    if (_cachedModel != null) {
      debugPrint('Loaded application data from cache');
    }

    // Fetch latest data from API
    try {
      final response = await http
          .post(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 15));
      log("API response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final companyResponse = CompanyResponse.fromJson(jsonData);

        if (companyResponse.data.isNotEmpty) {
          _cachedModel = companyResponse.data.first;

          // Store using CacheHelper
          await _cacheHelper!.cacheApplicationData(_cachedModel!);
          debugPrint('Application data fetched from API and cached');
        } else {
          debugPrint('No data found in API response');
        }
      } else {
        debugPrint('API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Fetch Application Error: $e');
    }
  }

  /// Access cached value anytime
  ApplicationModel? get applicationData => _cachedModel;
}
