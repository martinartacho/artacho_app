import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'profile_screen.dart';
import 'change_screen.dart';
import 'delete_account_screen.dart';
import 'notification_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../services/notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String? userName;
  String? userEmail;
  int _unreadNotifications = 0;

  final List<Widget> _screens = [
    const DashboardHome(),
    const NotificationsScreen(),
    const MoreScreen(),
  ];

  Future<void> _fetchUnreadNotifications() async {
    final count = await NotificationService.getUnreadCount();
    setState(() {
      _unreadNotifications = count;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchUnreadNotifications();
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
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        userName = user['name'] ?? 'Usuario';
        userEmail = user['email'] ?? 'correo@ejemplo.com';
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
        unreadNotifications: _unreadNotifications,
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bienvenido al Dashboard',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final prefs = snapshot.data!;
        final userJson = prefs.getString('user');
        final user = userJson != null ? jsonDecode(userJson) : {};
        final name = user['name'] ?? 'Usuario';
        final email = user['email'] ?? 'correo@ejemplo.com';

        return ListView(
          children: [
            const SizedBox(height: 32),
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Center(
              child: Text(name, style: Theme.of(context).textTheme.titleMedium),
            ),
            Center(
              child: Text(email, style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
                child: const Text('Modificar'),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Cambiar contraseña'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Eliminar cuenta'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeleteAccountScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await prefs.clear();
                if (context.mounted)
                  Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}
