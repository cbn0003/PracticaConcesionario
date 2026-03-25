

import 'package:flutter/material.dart';
import '../../repository/auth_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? '?',
                style: const TextStyle(fontSize: 40, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24),

            // Email
            Card(
              child: ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text(
                    'Correo electrónico:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(user?.email ?? 'Sin correo'),
              ),
            ),
            const SizedBox(height: 8),

            // UID
            Card(
              child: ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text(
                    'ID de usuario:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(user?.uid ?? '-'),
              ),
            ),
            const SizedBox(height: 32),

            // Botón logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                onPressed: () => _confirmLogout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // cierra el diálogo
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                      (route) => false,
                );
              }
            },
            child: const Text(
              'Salir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}