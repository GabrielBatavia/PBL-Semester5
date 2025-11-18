// lib/screens/LaporanKeuangan/semua_pemasukan.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/widgets/Pemasukan_filter.dart';

class Pemasukan extends StatelessWidget {
  const Pemasukan({super.key});

  // Data dummy
  final List<Map<String, String>> _pemasukanData = const [
    {
      "nama": "Iuran Bulanan",
      "jenis": "Iuran Warga",
      "tanggal": "15 Oktober 2025",
      "nominal": "Rp 500.000",
    },
    {
      "nama": "Sumbangan Acara",
      "jenis": "Donasi",
      "tanggal": "10 Oktober 2025",
      "nominal": "Rp 750.000",
    },
    {
      "nama": "Sewa Lapangan",
      "jenis": "Hasil Usaha Kampung",
      "tanggal": "12 Okt 2025",
      "nominal": "Rp 300.000",
    },
    {
      "nama": "Sewa Lapangan",
      "jenis": "Hasil Usaha Kampung",
      "tanggal": "12 Okt 2025",
      "nominal": "Rp 300.000",
    },
    {
      "nama": "Bantuan Pemerintah",
      "jenis": "Dana Bantuan Pemerintah",
      "tanggal": "12 Okt 2025",
      "nominal": "Rp 5.000.000",
    },
  ];

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Pemasukan"),
          content: const SingleChildScrollView(child: PemasukanFilter()),
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
        title: const Text("Semua Pemasukan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
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
                  'Daftar Pemasukan',
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Semua arus kas masuk kampung dalam satu tabel.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
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
                          colorScheme.primary.withOpacity(0.05),
                        ),
                        headingTextStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        columns: const [
                          DataColumn2(label: Text('Nama')),
                          DataColumn2(label: Text('Nominal'), numeric: true),
                        ],
                        rows: _pemasukanData.map((item) {
                          return DataRow2(
                            onTap: () {
                              context.push(
                                '/detail-pemasukan-all',
                                extra: item,
                              );
                            },
                            cells: [
                              DataCell(Text(item['nama']!)),
                              DataCell(
                                Text(
                                  item['nominal']!,
                                  style: TextStyle(
                                    color: Colors.green[700],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
