import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService {
  static Future<Dio> _getDio() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.baseUrl = dotenv.env['API_BASE_URL']!;
    return dio;
  }

  static Future<int> getUnreadCount() async {
    try {
      final dio = await _getDio();
      final response = await dio.get('/unread-count');
      print("🔢 Respuesta (Unread Count): ${response.data}");
      final count = response.data['count'];
      return count is int ? count : int.tryParse(count.toString()) ?? 0;
    } catch (e) {
      print('Error al obtener contador: $e');
      return 0;
    }
  }

  static Future<List<dynamic>> getNotifications() async {
    try {
      final dio = await _getDio();
      final response = await dio.get('/notifications-api');
      print('🔔 Respuesta completa: ${response.data}');
      return response.data['notifications'] ?? [];
    } on DioException catch (e) {
      // Manejo específico para errores de Dio
      if (e.response != null) {
        // El servidor respondió con un código de error
        print('⚠️ Error de API: ${e.response?.statusCode}');
        print('🔴 Error en la URL: ${e.requestOptions.uri}'); // URL completa
        // Puedes manejar diferentes códigos de estado específicamente
        switch (e.response?.statusCode) {
          case 404:
            print('🔍 Endpoint no encontrado. Verifica la URL.');
            // Podrías lanzar una excepción personalizada aquí si lo prefieres
            break;
          case 401:
            print('🔒 No autorizado. Token inválido o expirado.');
            break;
          case 500:
            print('⚙️ Error interno del servidor.');
            break;
          default:
            print('❌ Error HTTP no manejado: ${e.response?.statusCode}');
        }
      } else {
        // Error sin respuesta (problemas de conexión, timeout, etc.)
        print('🌐 Error de red: ${e.message}');
      }
      return [];
    } catch (e) {
      // Captura cualquier otra excepción que no sea DioException
      print('❓ Error inesperado: $e');
      return [];
    }
  }

  static Future<bool> markAsRead(String notificationId) async {
    try {
      final dio = await _getDio();
      final response = await dio.post('/$notificationId/mark-read-api');

      print('✅ Notificación marcada como leída: ID $notificationId');
      print('📊 Respuesta del servidor: ${response.data}');

      return response.statusCode == 200;
    } on DioException catch (e) {
      // Manejo específico para errores de Dio
      if (e.response != null) {
        // El servidor respondió con un código de error
        print(
          '⚠️ Error de API al marcar como leída: ${e.response?.statusCode}',
        );
        print('🔴 URL fallida: ${e.requestOptions.uri}');
        print('📄 Detalles del error: ${e.response?.data}');

        switch (e.response?.statusCode) {
          case 400:
            print('❌ Petición incorrecta: Verifica el ID de notificación');
            break;
          case 401:
            print('🔒 No autorizado: Token inválido o expirado');
            break;
          case 404:
            print('🔍 Notificación no encontrada (ID: $notificationId)');
            break;
          case 500:
            print('⚙️ Error interno del servidor al actualizar estado');
            break;
          default:
            print('❌ Error HTTP no manejado: ${e.response?.statusCode}');
        }
      } else {
        // Error sin respuesta (problemas de conexión)
        print('🌐 Error de red: ${e.message}');
        print('⌛ Posible timeout o fallo de conexión');
      }

      return false;
    } catch (e) {
      // Captura cualquier otra excepción no controlada
      print('❓ Error inesperado al marcar como leída: $e');
      print('🛠️ Stack trace: ${e is Error ? e.stackTrace : ''}');

      return false;
    }
  }
}
