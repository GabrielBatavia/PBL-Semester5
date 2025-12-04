// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../widgets/submenu_keuangan.dart';
import '../widgets/submenu_manajemen_pengguna.dart';
import '../widgets/submenu_channel_transfer.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.instance.getCachedRoleName(),
      builder: (context, snapshot) {
        // sementara loading – biar nggak blank
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // default: kalau belum ada role, anggap "warga"
        final role = snapshot.data ?? 'warga';
        return _MenuContent(role: role);
      },
    );
  }
}

class _MenuContent extends StatelessWidget {
  final String role; // admin, rt, rw, bendahara, sekretaris, warga

  const _MenuContent({super.key, required this.role});

  void _showFeatureNotReady(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ini sedang dalam pengembangan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Mapping role → menu yang boleh muncul
  bool _allowedForRole(String menuKey) {
    // kamu bisa edit mapping ini sesuai tabel yang sudah kita buat
    switch (role) {
      case 'admin':
        return true; // admin boleh semuanya
      case 'bendahara':
        return [
          'dashboard',
          'pemasukan',
          'pengeluaran',
          'laporan',
          'channel-transfer',
          'log',
        ].contains(menuKey);
      case 'rt':
        return [
          'dashboard',
          'kegiatan',
          'broadcast',
          'pesan-warga',
          'penerimaan-warga',
          'mutasi',
          'log',
          'marketplace',
        ].contains(menuKey);
      case 'rw':
        return [
          'dashboard',
          'kegiatan',
          'laporan',
          'mutasi',
          'log',
        ].contains(menuKey);
      case 'sekretaris':
        return [
          'dashboard',
          'data-warga',
          'penerimaan-warga',
          'mutasi',
          'log',
        ].contains(menuKey);
      case 'warga':
      default:
        return [
          'dashboard',
          'kegiatan',
          'pesan-warga',
          'marketplace',
        ].contains(menuKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> allMenuItems = [
      {
        'key': 'dashboard',
        'icon': Icons.dashboard,
        'title': 'Dashboard',
        'action': () => _showFeatureNotReady(context),
      },
      {
        'key': 'kegiatan',
        'icon': Icons.event_note,
        'title': 'Kegiatan',
        'action': () => context.push('/kegiatan'),
      },
      {
        'key': 'data-warga',
        'icon': Icons.home_work,
        'title': 'Data Warga & Rumah',
        'action': () => context.push('/data-warga-rumah'),
      },
      {
        'key': 'pemasukan',
        'icon': Icons.account_balance_wallet,
        'title': 'Pemasukan',
        'action': () => context.push('/menu-pemasukan'),
      },
      {
        'key': 'pengeluaran',
        'icon': Icons.monetization_on,
        'title': 'Pengeluaran',
        'action': () => context.push('/pengeluaran'),
      },
      {
        'key': 'laporan',
        'icon': Icons.assessment,
        'title': 'Laporan Keuangan',
        'action': () => context.push('/menu-laporan-keuangan'),
      },
      {
        'key': 'broadcast',
        'icon': Icons.campaign,
        'title': 'Broadcast',
        'action': () => _showFeatureNotReady(context),
      },
      {
        'key': 'pesan-warga',
        'icon': Icons.chat_bubble,
        'title': 'Pesan Warga',
        'action': () => _showFeatureNotReady(context),
      },
      {
        'key': 'penerimaan-warga',
        'icon': Icons.person_add_alt_1,
        'title': 'Penerimaan Warga',
        'action': () => _showFeatureNotReady(context),
      },
      {
        'key': 'mutasi',
        'icon': Icons.switch_account,
        'title': 'Mutasi Keluarga',
        'action': () => context.push('/mutasi'),
      },
      {
        'key': 'log',
        'icon': Icons.history,
        'title': 'Log Aktifitas',
        'action': () => context.goNamed('log-aktivitas'),
      },
      {
        'key': 'manajemen-pengguna',
        'icon': Icons.manage_accounts,
        'title': 'Manajemen Pengguna',
        'action': () => showSubMenuManajemenPengguna(context),
      },
      {
        'key': 'channel-transfer',
        'icon': Icons.wallet,
        'title': 'Channel Transfer',
        'action': () => showSubMenuChannelTransfer(context),
      },
      {
        'key': 'marketplace',
        'icon': Icons.storefront,
        'title': 'Marketplace Sayuran',
        'action': () => context.push('/marketplace'),
      },
    ];

    final menuItems =
        allMenuItems.where((m) => _allowedForRole(m['key'] as String)).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Menu (${role.toUpperCase()})"),
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
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Semua Fitur',
                    style: theme.textTheme.displayLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return _buildMenuItem(
                        context,
                        icon: item['icon'] as IconData,
                        title: item['title'] as String,
                        onTap: item['action'] as VoidCallback,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
