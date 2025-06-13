import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _linkSent = false;
  String? _errorMessage;
  int _cooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().post('/forgot-password', {
        'email': _emailController.text.trim(),
      });

      setState(() {
        _linkSent = true;
        _cooldown = 60;
      });

      _cooldownTimer?.cancel();
      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_cooldown > 0) {
            _cooldown--;
          } else {
            timer.cancel();
          }
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "📩 Hem enviat l'enllaç de restabliment de contrasenya al teu correu electrònic.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
    } on DioException catch (e) {
      setState(() {
        _errorMessage = e.response?.data['message'] ?? 'Error inesperado';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_linkSent)
                const Text(
                  "Hem enviat l'enllaç de restabliment de contrasenya al teu correu electrònic.",
                  style: TextStyle(color: Colors.green),
                ),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              const Text(
                'Introduce tu email y te enviaremos un enlace para restablecer tu contraseña.',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El email es obligatorio';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Introduce un email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: (_isLoading || _linkSent) ? null : _sendResetLink,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Enviar enlace'),
              ),
              const SizedBox(height: 10),
              if (_linkSent)
                Column(
                  children: [
                    if (_cooldown > 0) Text('Volver en $_cooldown segundos'),
                    TextButton(
                      onPressed: _cooldown == 0
                          ? () {
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Volver'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
