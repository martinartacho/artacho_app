import 'package:flutter/material.dart';
import 'package:artacho_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:artacho_app/widgets/custom_app_bar.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar cuenta?'),
        content: const Text('Esta acción no se puede deshacer. ¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await UserService().deleteAccount();

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar cuenta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Eliminar cuenta'),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _deleteAccount(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Eliminar cuenta permanentemente'),
        ),
      ),
    );
  }
}
