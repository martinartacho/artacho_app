import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'profile':
                Navigator.pushNamed(context, '/profile');
                break;
              case 'change_password':
                Navigator.pushNamed(context, '/change-password');
                break;
              case 'delete_account':
                Navigator.pushNamed(context, '/delete-account');
                break;
              case 'logout':
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'profile', child: Text('Perfil')),
            PopupMenuItem(
              value: 'change_password',
              child: Text('Cambiar contraseña'),
            ),
            PopupMenuItem(
              value: 'delete_account',
              child: Text('Eliminar cuenta'),
            ),
            PopupMenuItem(value: 'logout', child: Text('Cerrar sesión')),
          ],
        ),
      ],
    );
  }
}
