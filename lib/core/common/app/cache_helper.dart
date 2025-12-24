import 'dart:convert';
import 'dart:developer';
import 'package:mediecom/core/common/app/application_details.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your ApplicationModel
// import 'package:mediecom/path/to/application_model.dart';

class CacheHelper {
  const CacheHelper(this._prefs);

  final SharedPreferences _prefs;

  static const _isLoggedInKey = 'is_logged_in';
  static const _firstTimerKey = 'is_user_first_timer';
  static const _userIdKey = 'user_id';
  static const _userKey = 'user';
  static const _fcmTokenKey = 'fcm_token';

  /* -----------------------------------------
     APPLICATION DATA CACHE
  ----------------------------------------- */
  static const _applicationDataKey = 'application_data';

  /// Cache application data
  /// Cache application data
  Future<bool> cacheApplicationData(ApplicationModel applicationModel) async {
    try {
      final jsonString = jsonEncode(applicationModel.toJson());
      return await _prefs.setString(_applicationDataKey, jsonString);
    } catch (e) {
      appLog("cacheApplicationData error: $e");
      return false;
    }
  }

  /// Get cached application data
  ApplicationModel? getApplicationData() {
    final jsonString = _prefs.getString(_applicationDataKey);
    if (jsonString == null) {
      appLog("No cached application data");
      return null;
    }

    try {
      final jsonMap = jsonDecode(jsonString);
      return ApplicationModel.fromJson(jsonMap);
    } catch (e) {
      appLog("getApplicationData decode error: $e");
      return null;
    }
  }

  /// Clear application data cache
  Future<void> clearApplicationData() async {
    await _prefs.remove(_applicationDataKey);
  }

  /* -----------------------------------------
     FCM TOKEN
  ----------------------------------------- */

  /// CACHE FCM TOKEN
  Future<bool> cacheFcmToken(String token) async {
    try {
      return await _prefs.setString(_fcmTokenKey, token);
    } catch (e) {
      appLog("cacheFcmToken error: $e");
      return false;
    }
  }

  /// GET FCM TOKEN
  String? getFcmToken() {
    return _prefs.getString(_fcmTokenKey);
  }

  /* -----------------------------------------
     SESSION MANAGEMENT
  ----------------------------------------- */

  /// Reset session
  Future<void> resetSession() async {
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userKey);
    // Optionally clear application data on logout
    // await clearApplicationData();
  }

  // Check if user is logged in
  bool isLoggedIn() => _prefs.getBool(_isLoggedInKey) ?? false;

  // Set the logged-in status
  Future<void> setIsLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  // Check if user is a first-time user
  bool isFirstTime() => _prefs.getBool(_firstTimerKey) ?? true;

  // Set the first-time user status
  Future<void> setIsFirstTime(bool value) async {
    await _prefs.setBool(_firstTimerKey, value);
  }

  /* -----------------------------------------
     USER MANAGEMENT
  ----------------------------------------- */

  /// Cache user ID(Access token)
  Future<bool> cacheUserId(String userId) async {
    try {
      final result = await _prefs.setString(_userIdKey, userId);
      return result;
    } catch (_) {
      return false;
    }
  }

  /// Get user ID
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Cache user
  Future<bool> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      final result = await _prefs.setString(_userKey, userJson);
      return result;
    } catch (e) {
      appLog('Error caching user: $e');
      return false;
    }
  }

  /// Get UserDetails
  UserModel? getUser() {
    final userJson = _prefs.getString(_userKey);

    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      final user = UserModel.fromJson(userMap);
      return user;
    } else {
      appLog('getUser: User does not exist');
      return null;
    }
  }

  /* -----------------------------------------
     LOCATION CACHE KEYS
  ----------------------------------------- */

  static const _latKey = 'user_lat';
  static const _lngKey = 'user_lng';
  static const _locationKey = 'user_location_details';
  static const _fullAddressKey = 'full_address';

  /* -----------------------------------------
     CACHE LATITUDE & LONGITUDE
  ----------------------------------------- */

  Future<bool> cacheLatitude(double lat) async {
    try {
      return await _prefs.setDouble(_latKey, lat);
    } catch (e) {
      appLog("cacheLatitude error: $e");
      return false;
    }
  }

  Future<bool> cacheLongitude(double lng) async {
    try {
      return await _prefs.setDouble(_lngKey, lng);
    } catch (e) {
      appLog("cacheLongitude error: $e");
      return false;
    }
  }

  double? getLatitude() => _prefs.getDouble(_latKey);
  double? getLongitude() => _prefs.getDouble(_lngKey);

  /* -----------------------------------------
     CACHE LOCATION DETAILS (CITY + DISTRICT)
  ----------------------------------------- */

  Future<bool> cacheLocationDetails({
    required String city,
    required String district,
  }) async {
    try {
      final map = {"city": city, "district": district};
      final jsonString = jsonEncode(map);
      return await _prefs.setString(_locationKey, jsonString);
    } catch (e) {
      appLog("cacheLocationDetails error: $e");
      return false;
    }
  }

  /* -----------------------------------------
     FULL ADDRESS CACHE
  ----------------------------------------- */

  /// Cache full address
  Future<bool> cacheFullAddress({required String address}) async {
    try {
      return await _prefs.setString(_fullAddressKey, address);
    } catch (e) {
      appLog("cacheFullAddress error: $e");
      return false;
    }
  }

  /// Get full cached address
  String? getFullAddress() {
    final address = _prefs.getString(_fullAddressKey);
    if (address == null) {
      appLog("No cached full address");
      return null;
    }
    return address;
  }

  Map<String, String>? getLocationDetails() {
    final jsonString = _prefs.getString(_locationKey);

    if (jsonString == null) {
      appLog("No cached location details");
      return null;
    }

    try {
      final map = jsonDecode(jsonString);
      return {"city": map["city"], "district": map["district"]};
    } catch (e) {
      appLog("getLocationDetails decode error: $e");
      return null;
    }
  }

  /* -----------------------------------------
     CLEAR LOCATION CACHE
  ----------------------------------------- */

  Future<void> clearLocation() async {
    await _prefs.remove(_latKey);
    await _prefs.remove(_lngKey);
    await _prefs.remove(_locationKey);
    await _prefs.remove(_fullAddressKey);
  }

  /* -----------------------------------------
     CLEAR ALL CACHE
  ----------------------------------------- */

  Future<void> clearAllCache() async {
    await resetSession();
    await clearLocation();
    await clearApplicationData();
    await _prefs.remove(_fcmTokenKey);
  }
}
