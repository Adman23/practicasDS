import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


/*

 */
class TokenService {

  Future<void> saveToken (String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString("auth_token", token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString("auth_token");
  }

  Future<void> clearToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove("auth_token");
  }

}