// lib/screens/Pemasukan/daftar_tagihan.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'tagihan_table.dart';

class DaftarTagihan extends StatefulWidget {
  const DaftarTagihan({super.key});

  @override
  State<DaftarTagihan> createState() => _DaftarTagihanState();
}

class _DaftarTagihanState extends State<DaftarTagihan> {
  // Data dummy tanpa tanggal
  final List<Map<String, String>> _daftarTagihan = [
    {
      "no": "1",
      "namaKeluarga": "Keluarga Aziz",
      "statusKeluarga": "Aktif",
      "jenis": "Bulanan",
      "kodeTagihan": "IR12345",
      "nominal": "Rp 10.000",
      "periode": "2 Januari 2023",
      "status": "Belum Lunas",
    },
    {
      "no": "2",
      "namaKeluarga": "Keluarga Hilmi",
      "statusKeluarga": "Aktif",
      "jenis": "Bulanan",
      "kodeTagihan": "IR12346",
      "nominal": "Rp 10.000",
      "periode": "2 Januari 2023",
      "status": "Belum Lunas",
    },
    {
      "no": "3",
      "namaKeluarga": "Keluarga Dio",
      "statusKeluarga": "Aktif",
      "jenis": "Bulanan",
      "kodeTagihan": "IR12347",
      "nominal": "Rp 10.000",
      "periode": "2 Januari 2023",
      "status": "Belum Lunas",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Tagihan Iuran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu-pemasukan'),
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
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar Tagihan Iuran',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pantau status tagihan iuran untuk semua keluarga aktif.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TagihanTable(
                      daftarTagihan: _daftarTagihan,
                      onViewPressed: (item) {
                        context.push('/detail-tagihan', extra: item);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
