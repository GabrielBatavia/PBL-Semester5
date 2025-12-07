import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/utils/session.dart';
import '../services/auth_service.dart';

bool _allowedForRole(String role, String menuKey) {
  switch (role) {
    case 'admin':
      return true;
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

void showMenuPopUp(BuildContext context) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final viewInsets = MediaQuery.of(sheetContext).viewInsets;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: viewInsets.bottom + 16,
          ),
          child: const _MenuPopUpContent(),
        ),
      );
    },
  );
}

class _MenuPopUpContent extends StatelessWidget {
  const _MenuPopUpContent({super.key});

  void showFeatureNotReady(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ini sedang dalam pengembangan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder<String?>(
      future: SessionManager.getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            height: 160,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data ?? 'warga';

        // daftar semua menu (pakai key untuk filter)
        final List<Map<String, dynamic>> allMenuItems = [
          {
            'key': 'dashboard',
            'icon': Icons.dashboard_outlined,
            'title': 'Dashboard',
            'action': () => showFeatureNotReady(context),
          },
          {
            'key': 'kegiatan',
            'icon': Icons.event_note,
            'title': 'Kegiatan',
            'action': () => context.push('/kegiatan'),
          },
          {
            'key': 'data-warga',
            'icon': Icons.home_work_outlined,
            'title': 'Data Warga & Rumah',
            'action': () => context.push('/data-warga-rumah'),
          },
          {
            'key': 'pemasukan',
            'icon': Icons.account_balance_wallet_outlined,
            'title': 'Pemasukan',
            'action': () => context.push('/menu-pemasukan'),
          },
          {
            'key': 'pengeluaran',
            'icon': Icons.monetization_on_outlined,
            'title': 'Pengeluaran',
            'action': () => context.push('/pengeluaran'),
          },
          {
            'key': 'laporan',
            'icon': Icons.assessment_outlined,
            'title': 'Laporan Keuangan',
            'action': () => context.push('/laporan-keuangan'),
          },
          {
            'key': 'broadcast',
            'icon': Icons.campaign_outlined,
            'title': 'Broadcast',
            'action': () => context.push('/broadcast'),
          },
          {
            'key': 'pesan-warga',
            'icon': Icons.chat_bubble_outline,
            'title': 'Pesan Warga',
            'action': () => showFeatureNotReady(context),
          },
          {
            'key': 'penerimaan-warga',
            'icon': Icons.person_add_alt_1_outlined,
            'title': 'Penerimaan Warga',
            'action': () => context.push('/penerimaan-warga'),
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
            'action': () => context.push('/log-aktivitas'),
          },
          {
            'key': 'manajemen-pengguna',
            'icon': Icons.manage_accounts_outlined,
            'title': 'Manajemen Pengguna',
            'action': () => context.push('/manajemen-pengguna'),
          },
          {
            'key': 'channel-transfer',
            'icon': Icons.wallet_outlined,
            'title': 'Channel Transfer',
            'action': () => context.push('/channel-transfer'),
          },
          {
            'key': 'aspirasi',
            'icon': Icons.forum_outlined,
            'title': 'Aspirasi',
            'action': () => context.push('/dashboard-aspirasi'),
          },
          {
            'key': 'marketplace',
            'icon': Icons.storefront_outlined,
            'title': 'Marketplace Sayuran',
            'action': () => context.push('/marketplace'),
          },
        ];

        final menuItems = allMenuItems
            .where((m) => _allowedForRole(role, m['key'] as String))
            .toList();

        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Menu Utama (${role.toUpperCase()})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Future.microtask(() {
                              if (context.mounted) item['action']();
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6A11CB),
                                          Color(0xFF2575FC)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Icon(
                                      item['icon'] as IconData,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['title'] as String,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
