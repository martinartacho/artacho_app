import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hartacho_app/core/config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio dio;

  ApiService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📡 Request a: ${options.uri}');
          print('🔐 Headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _setAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('🔍 Token guardado en apiservice _setAuthToken : $token');
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  // ✅ Nuevo método público para forzar el seteo del token
  Future<void> initAuthToken() async => await _setAuthToken();

  Future<Response> post(
    String path,
    Map<String, dynamic> data, {
    bool auth = true,
  }) async {
    if (auth) await _setAuthToken();
    return dio.post(path, data: data);
  }

  Future<Response> put(
    String path,
    Map<String, dynamic> data, {
    bool auth = true,
  }) async {
    if (auth) await _setAuthToken();
    print('Usando token en PUT: ${dio.options.headers['Authorization']}');
    return dio.put(path, data: data);
  }

  Future<Response> get(String path, {bool auth = true}) async {
    if (auth) await _setAuthToken();
    return dio.get(path);
  }

  Future<Response> delete(String path, {bool auth = true}) async {
    if (auth) await _setAuthToken();
    return dio.delete(path);
  }
}
