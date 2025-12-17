// lib/widgets/dashboard_statistik.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardStatistik extends StatelessWidget {
  final String role;

  const DashboardStatistik({super.key, required this.role});

  List<Map<String, dynamic>> _items() {
    switch (role) {
      case 'warga':
        return [
          {'label': 'Marketplace', 'icon': FontAwesomeIcons.store},
          {'label': 'Kegiatan', 'icon': FontAwesomeIcons.calendarDays},
          {'label': 'Pesan Warga', 'icon': FontAwesomeIcons.solidMessage},
        ];
      case 'rt':
        return [
          {'label': 'Pesan Warga', 'icon': FontAwesomeIcons.solidMessage},
          {'label': 'Broadcast', 'icon': FontAwesomeIcons.bullhorn},
          {'label': 'Kegiatan RT', 'icon': FontAwesomeIcons.calendarDays},
        ];
      case 'rw':
        return [
          {'label': 'Rekap RW', 'icon': FontAwesomeIcons.chartPie},
          {'label': 'Keuangan', 'icon': FontAwesomeIcons.wallet},
          {'label': 'Kegiatan RW', 'icon': FontAwesomeIcons.calendarDays},
        ];
      case 'bendahara':
        return [
          {'label': 'Pemasukan', 'icon': FontAwesomeIcons.arrowDown},
          {'label': 'Pengeluaran', 'icon': FontAwesomeIcons.arrowUp},
          {'label': 'Transfer', 'icon': FontAwesomeIcons.wallet},
        ];
      case 'sekretaris':
        return [
          {'label': 'Data Warga', 'icon': FontAwesomeIcons.peopleGroup},
          {'label': 'Mutasi', 'icon': FontAwesomeIcons.rightLeft},
          {'label': 'Penerimaan', 'icon': FontAwesomeIcons.userPlus},
        ];
      case 'admin':
      default:
        return [
          {'label': 'Users', 'icon': FontAwesomeIcons.userGear},
          {'label': 'Aktivitas', 'icon': FontAwesomeIcons.listCheck},
          {'label': 'Global', 'icon': FontAwesomeIcons.globe},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _items();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Modul', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          // 🔥 Tidak berubah dari versi lama → Row 3 card, fixed size
          Row(
            children: [
              for (final item in items)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _StatCard(
                      label: item['label'],
                      icon: item['icon'],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88, // 🔥 Tetap sama seperti versi lama
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6A11CB),
            Color(0xFF2575FC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // 🔥 agar tidak melebihi box
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
