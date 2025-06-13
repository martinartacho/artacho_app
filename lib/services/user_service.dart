import 'api_service.dart';

class UserService {
  final _api = ApiService();

  Future<bool> updateProfile(String name, String email) async {
    print('Estamos en updateProfile');

    try {
      final response = await _api.put('/profile', {
        'name': name,
        'email': email,
      });
      return response.statusCode == 200;
    } catch (e) {
      // print('response  false en updateProfile $e');
      return false;
    }
  }

  Future<bool> changePassword(String current, String newPassword) async {
    try {
      final response = await _api.put('/change-password', {
        'current_password': current,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final response = await _api.delete('/delete-account');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
