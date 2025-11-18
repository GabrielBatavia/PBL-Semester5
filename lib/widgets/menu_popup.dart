// lib/widgets/menu_popup.dart
// lib/widgets/menu_popup.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          child: _MenuPopUpContent(),
        ),
      );
    },
  );
}

class _MenuPopUpContent extends StatelessWidget {
  _MenuPopUpContent({super.key});

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

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.dashboard_outlined,
        'title': 'Dashboard',
        'action': () => showFeatureNotReady(context),
      },
      {
        'icon': Icons.event_note,
        'title': 'Kegiatan',
        'action': () => context.push('/kegiatan'),
      },
      {
        'icon': Icons.home_work_outlined,
        'title': 'Data Warga & Rumah',
        'action': () => context.push('/data-warga-rumah'),
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'title': 'Pemasukan',
        'action': () => context.push('/menu-pemasukan'),
      },
      {
        'icon': Icons.monetization_on_outlined,
        'title': 'Pengeluaran',
        'action': () => context.push('/pengeluaran'),
      },
      {
        'icon': Icons.assessment_outlined,
        'title': 'Laporan Keuangan',
        'action': () => context.push('/laporan-keuangan'),
      },
      {
        'icon': Icons.campaign_outlined,
        'title': 'Broadcast',
        'action': () => context.push('/broadcast'),
      },
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'Pesan Warga',
        'action': () => showFeatureNotReady(context),
      },
      {
        'icon': Icons.person_add_alt_1_outlined,
        'title': 'Penerimaan Warga',
        'action': () => context.push('/penerimaan-warga'),
      },
      {
        'icon': Icons.switch_account,
        'title': 'Mutasi Keluarga',
        'action': () => context.push('/mutasi'),
      },
      {
        'icon': Icons.history,
        'title': 'Log Aktifitas',
        'action': () => context.push('/log-aktivitas'),
      },
      {
        'icon': Icons.manage_accounts_outlined,
        'title': 'Manajemen Pengguna',
        'action': () => context.push('/manajemen-pengguna'),
      },
      {
        'icon': Icons.wallet_outlined,
        'title': 'Channel Transfer',
        'action': () => context.push('/channel-transfer'),
      },
      {
        'icon': Icons.forum_outlined,
        'title': 'Aspirasi',
        'action': () => context.push('/dashboard-aspirasi'),
      },
    ];

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
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
                    'Menu Utama',
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    // ➜ bikin cell sedikit lebih tinggi
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          item['action']();
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
                                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  item['icon'],
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['title'],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
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
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
