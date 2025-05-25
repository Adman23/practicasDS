import 'package:shared_preferences/shared_preferences.dart';

/*

 */
class TokenService {
  static const String AUTH_TOKEN_KEY = 'auth_token';

  Future<void> saveToken (String token) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(AUTH_TOKEN_KEY, token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(AUTH_TOKEN_KEY);
  }

  Future<void> clearToken() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(AUTH_TOKEN_KEY);
  }

}