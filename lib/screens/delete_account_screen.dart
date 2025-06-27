import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isDeleting = false;

  void _handleDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: const Text('Esta acción eliminará tu cuenta permanentemente.'),
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

    if (confirm == true) {
      setState(() => _isDeleting = true);

      // Aquí iría tu lógica para eliminar la cuenta en el backend.
      await Future.delayed(const Duration(seconds: 2)); // Simulación

      setState(() => _isDeleting = false);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cuenta eliminada')));

      // Redirige al login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar cuenta')),
      body: Center(
        child: _isDeleting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _handleDeleteAccount,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar mi cuenta'),
              ),
      ),
    );
  }
}
