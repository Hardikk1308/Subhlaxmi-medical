
class Cache {
  Cache._internal();

  static final Cache instance = Cache._internal();

  String? _sessionToken;
  String? _refreshToken;
  String? _userId;


  String? get sessionToken => _sessionToken;
  String? get refreshToken => _refreshToken;

  String? get userId => _userId;

  void setSessionToken(String? newToken) {
    if (_sessionToken != newToken) _sessionToken = newToken;
  }

  void setRefreshToken(String? newToken) {
    if (_refreshToken != newToken) _refreshToken = newToken;
  }

  void setUserId(String? userId) {
    if (_userId != userId) _userId = userId;
  }


  void resetSession() {
    setSessionToken(null);
    setUserId(null);
  }
}
