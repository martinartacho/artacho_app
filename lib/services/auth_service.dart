import 'dart:convert';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['access_token']?.toString();
        final userJson = body['user'];

        if (token == null || userJson == null) return null;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(userJson));

        return userJson;
      } else {
        print('❌ Login error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('🌐 Login exception: $e');
      return null;
    }
  }

  String getDeviceType() {
    /*if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown'; */
    return 'mobile'; // Valor fijo para móvil
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  Future<Map<String, dynamic>> saveFcmToken(
    String fcmToken,
    String token,
  ) async {
    final url = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/notifications/save-fcm-token',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'token': fcmToken, 'device_type': getDeviceType()}),
      );

      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'body': response.body,
      };
    } catch (e) {
      print('🌐 Error guardando FCM: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}
