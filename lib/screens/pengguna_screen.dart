// lib/screens/pengguna_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';

class PenggunaScreen extends StatelessWidget {
  const PenggunaScreen({super.key});

  Future<Map<String, String?>> _loadProfile() async {
    final name = await AuthService.instance.getCachedUserName();
    final role = await AuthService.instance.getCachedRoleName();
    // kalau suatu saat ada email, tinggal tambahkan di sini
    return {
      'name': name,
      'role': role,
    };
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout();
    // arahkan ke halaman login (sesuaikan dengan rute login-mu)
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Akun Pengguna'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, String?>>(
            future: _loadProfile(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;
              final name = data['name'] ?? 'Pengguna';
              final role = (data['role'] ?? 'warga').toUpperCase();

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // kartu profil
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Role: $role',
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Pengaturan Akun',
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 12),

                    // ganti akun (sementara sama dengan logout)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.switch_account),
                        title: const Text('Ganti Akun'),
                        subtitle: const Text('Login dengan akun yang berbeda'),
                        onTap: () => _logout(context),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Keluar',
                          style: TextStyle(color: Colors.red),
                        ),
                        subtitle: const Text('Keluar dari aplikasi'),
                        onTap: () => _logout(context),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
