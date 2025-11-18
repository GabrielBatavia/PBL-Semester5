// lib/screens/pengeluaran/pengeluaran_screen.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/widgets/pengeluaran_filter.dart';

class PengeluaranScreen extends StatelessWidget {
  const PengeluaranScreen({super.key});

  // Data dummy
  final List<Map<String, String>> _pengeluaranData = const [
    {
      "nama": "Beli Sapu",
      "kategori": "Keamanan & Kebersihan",
      "tanggal": "22 Oktober 2025",
      "nominal": "Rp 25.000",
    },
    {
      "nama": "Perbaikan Lampu Jalan",
      "kategori": "Pemeliharaan Fasilitas",
      "tanggal": "17 Oktober 2025",
      "nominal": "Rp 150.000",
    },
    {
      "nama": "Santunan Anak Yatim",
      "kategori": "Kegiatan Sosial",
      "tanggal": "15 Oktober 2025",
      "nominal": "Rp 50.000",
    },
    {
      "nama": "Pembangunan Pos RW",
      "kategori": "Pembangunan",
      "tanggal": "11 September 2025",
      "nominal": "Rp 320.000",
    },
    {
      "nama": "Lomba 17an",
      "kategori": "Kegiatan Warga",
      "tanggal": "10 Agustus 2025",
      "nominal": "Rp 500.000",
    },
  ];

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Pengeluaran"),
          content: const SingleChildScrollView(child: PengeluaranFilter()),
          actions: <Widget>[
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Cari"),
              onPressed: () {
                // TODO: Tambahkan logika filter
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Laporan Pengeluaran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tambah-pengeluaran'),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
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
                  'Laporan Pengeluaran',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pantau semua pengeluaran kas lingkungan.',
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
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      headingRowColor: MaterialStateProperty.all(
                        theme.colorScheme.primary.withOpacity(0.1),
                      ),
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                      columns: const [
                        DataColumn2(label: Text('Nama')),
                        DataColumn2(
                          label: Text('Nominal'),
                          numeric: true,
                        ),
                      ],
                      rows: _pengeluaranData.map((item) {
                        return DataRow2(
                          onTap: () {
                            context.push('/detail-pengeluaran', extra: item);
                          },
                          cells: [
                            DataCell(Text(item['nama']!)),
                            DataCell(
                              Text(
                                item['nominal']!,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
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
