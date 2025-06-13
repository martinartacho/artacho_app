import 'package:flutter/foundation.dart';

class AppConfig {
  static const bool enableFirebase = true; // o false

  static String get baseUrl {
    return kReleaseMode
        ? 'https://your.api.url/api'
        : (kIsWeb ? 'https://your.api.url/api' : 'http://10.0.2.2:8000/api');
  }

  static Uri get loginEndpoint => Uri.parse('$baseUrl/login');
  static Uri get fcmTokenEndpoint => Uri.parse('$baseUrl/save-fcm-token');
  static Uri get saveFcmTokenEndpoint => Uri.parse('$baseUrl/save-fcm-token');
  static const String tokenStorageKey = 'token';
  static const String userStorageKey = 'user';
  static const String fcmTokenStorageKey = 'fcm_token';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
