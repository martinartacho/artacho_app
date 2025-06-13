import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupFirebaseListeners();
  }

  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${message.notification?.title ?? 'Notificación'}: ${message.notification?.body ?? ''}',
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    final token = prefs.getString('token');

    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        userName = user['name'] ?? 'Usuario';
        userEmail = user['email'] ?? 'correo@ejemplo.com';
      });
    } else {
      print("User JSON desde SharedPreferences: null");
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');

      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  Future<void> _goToProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _goToProfile();
                  break;
                case 'change_password':
                  Navigator.pushNamed(context, '/change-password');
                  break;
                case 'delete_account':
                  Navigator.pushNamed(context, '/delete-account');
                  break;
                case 'logout':
                  _logout(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Perfil'),
                ),
              ),
              const PopupMenuItem(
                value: 'change_password',
                child: ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Cambiar contraseña'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete_account',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Eliminar cuenta'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar sesión'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tu dashboard en Hartacho',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (userName != null) Text('Nombre: $userName'),
            if (userEmail != null) Text('Email: $userEmail'),
          ],
        ),
      ),
    );
  }
}
