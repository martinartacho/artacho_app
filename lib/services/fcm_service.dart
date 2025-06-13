import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config.dart';

class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initializeAndSaveToken() async {
    try {
      if (kIsWeb) {
        await _firebaseMessaging.requestPermission();
      }

      final token = await _firebaseMessaging.getToken(
        vapidKey: kIsWeb ? dotenv.env['FIREBASE_VAPID_KEY'] : null,
      );

      if (token != null) {
        await _saveTokenToBackend(token);
      }
    } catch (_) {}
  }

  static Future<void> _saveTokenToBackend(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(AppConfig.tokenStorageKey);

    if (userToken == null) return;

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/save-fcm-token'),
      headers: {
        'Content-Type': 'application/json',
        AppConfig.authorizationHeader: '${AppConfig.bearerPrefix}$userToken',
      },
      body: jsonEncode({
        'token': token,
        'device_type': kIsWeb ? 'web' : 'mobile',
      }),
    );

    if (response.statusCode != 200) {
      // Puedes registrar un error aquí si lo deseas
    }
  }
}
