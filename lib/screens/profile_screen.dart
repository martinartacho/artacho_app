import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hartacho_app/services/user_service.dart';
import 'package:hartacho_app/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print('Estamos en _loadUserData');

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    print('User JSON desde SharedPreferences: $userJson');

    if (userJson != null) {
      final user = jsonDecode(userJson);
      print('Decodificado: $user');
      setState(() {
        _nameController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
      });
    }
  }

  Future<void> _saveProfile() async {
    print('Estamos en _saveProfile');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    //  print('Token A saveProfile: $token'); // Debug crucial
    print('🔍 Token guardado en profile_screen saveProfile : $token');

    final success = await UserService().updateProfile(
      _nameController.text,
      _emailController.text,
    );

    if (success) {
      print('Estamos en succes');

      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = jsonDecode(userJson);
        user['name'] = _nameController.text;
        user['email'] = _emailController.text;
        await prefs.setString('user', jsonEncode(user));
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar perfil screen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Perfil'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
