// lib/screens/LaporanKeuangan/menu_laporan_keuangan.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuLaporanKeuangan extends StatefulWidget {
  const MenuLaporanKeuangan({super.key});

  @override
  State<MenuLaporanKeuangan> createState() => _MenuLaporanKeuanganState();
}

class _MenuLaporanKeuanganState extends State<MenuLaporanKeuangan> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 24, right: 16, left: 16, bottom: 24),
            child: const MenuLaporanKeuanganHeader(),
          ),
        ),
      ),
    );
  }
}

class MenuLaporanKeuanganItem extends StatefulWidget {
  const MenuLaporanKeuanganItem({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  State<MenuLaporanKeuanganItem> createState() =>
      _MenuLaporanKeuanganItemState();
}

class _MenuLaporanKeuanganItemState extends State<MenuLaporanKeuanganItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push(widget.route),
      onHover: (hovering) {
        setState(() {
          _isHovering = hovering;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: _isHovering
              ? colorScheme.surfaceVariant.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(widget.icon, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuLaporanKeuanganHeader extends StatelessWidget {
  const MenuLaporanKeuanganHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final items = [
      {
        'label': 'Semua Pemasukan',
        'icon': Icons.account_balance_wallet_outlined,
        'route': '/semua-pemasukan',
      },
      {
        'label': 'Semua Pengeluaran',
        'icon': Icons.monetization_on_outlined,
        'route': '/semua-pengeluaran',
      },
      {
        'label': 'Cetak Laporan',
        'icon': Icons.print_outlined,
        'route': '/cetak-laporan',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pilih Menu Laporan Keuangan', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Lihat rekap pemasukan, pengeluaran, dan cetak laporan resmi.',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((e) {
              return Expanded(
                child: MenuLaporanKeuanganItem(
                  icon: e['icon'] as IconData,
                  label: e['label'] as String,
                  route: e['route'] as String,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
