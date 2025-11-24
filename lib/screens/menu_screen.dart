// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/widgets/submenu_keuangan.dart';
import 'package:jawaramobile_1/widgets/submenu_manajemen_pengguna.dart';
import 'package:jawaramobile_1/widgets/submenu_channel_transfer.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void showFeatureNotReady() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur ini sedang dalam pengembangan'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.dashboard,
        'title': 'Dashboard',
        'action': showFeatureNotReady,
      },
      {
        'icon': Icons.event_note,
        'title': 'Kegiatan',
        'action': () => context.push('/kegiatan'),
      },
      {
        'icon': Icons.home_work,
        'title': 'Data Warga & Rumah',
        'action': () => context.push('/data-warga-rumah'),
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': 'Pemasukan',
        'action': () => context.push('/menu-pemasukan'),
      },
      {
        'icon': Icons.monetization_on,
        'title': 'Pengeluaran',
        'action': () => context.push('/pengeluaran'),
      },
      {
        'icon': Icons.assessment,
        'title': 'Laporan Keuangan',
        'action': () => showSubMenuKeuangan(context),
      },
      {
        'icon': Icons.campaign,
        'title': 'Broadcast',
        'action': showFeatureNotReady,
      },
      {
        'icon': Icons.chat_bubble,
        'title': 'Pesan Warga',
        'action': showFeatureNotReady,
      },
      {
        'icon': Icons.person_add_alt_1,
        'title': 'Penerimaan Warga',
        'action': showFeatureNotReady,
      },
      {
        'icon': Icons.switch_account,
        'title': 'Mutasi Keluarga',
        'action': () => context.push('/mutasi'),
      },
      {
        'icon': Icons.history,
        'title': 'Log Aktifitas',
        'action': () => context.goNamed('log-aktivitas'),
      },
      {
        'icon': Icons.manage_accounts,
        'title': 'Manajemen Pengguna',
        'action': () => showSubMenuManajemenPengguna(context),
      },
      {
        'icon': Icons.wallet,
        'title': 'Channel Transfer',
        'action': () => showSubMenuChannelTransfer(context),
      },
      {
        'icon': Icons.storefront,
        'title': 'Marketplace Sayuran',
        'action': () => context.push('/marketplace'),
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Menu"),
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
                        icon: item['icon'],
                        title: item['title'],
                        onTap: item['action'],
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

// NOTE: pastikan import ini ada di atas file aslinya
