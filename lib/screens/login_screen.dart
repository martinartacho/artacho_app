import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:artacho_app/screens/dashboard_screen.dart';
import 'package:artacho_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print('📲 Intentando login con: $email');

    final user = await _authService.login(email, password);

    setState(() => isLoading = false);

    if (user != null) {
      final token = await AuthService.getToken();
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null && fcmToken.isNotEmpty && token != null) {
        final fcmSaved = await _authService.saveFcmToken(fcmToken, token);
        print(fcmSaved ? '✅ FCM guardado' : '❌ FCM no guardado');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      print('❌ Login fallido');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales incorrectas o error en el servidor.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: const Text('Iniciar sesión'),
                  ),
          ],
        ),
      ),
    );
  }
}
