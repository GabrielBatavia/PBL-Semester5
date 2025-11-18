// lib/screens/Pemasukan/lain_lain.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/widgets/Pemasukan_filter.dart';

class PemasukanLain extends StatelessWidget {
  const PemasukanLain({super.key});

  // Data dummy
  final List<Map<String, String>> _pemasukanData = const [
    {
      "no": "1",
      "nama": "Iuran Warga",
      "jenis": "Iuran",
      "tanggal": "15 Okt 2025",
      "nominal": "Rp 500.000",
    },
    {
      "no": "2",
      "nama": "Sumbangan Acara",
      "jenis": "Sumbangan",
      "tanggal": "14 Okt 2025",
      "nominal": "Rp 750.000",
    },
    {
      "no": "3",
      "nama": "Sewa Lapangan",
      "jenis": "Sewa Aset",
      "tanggal": "12 Okt 2025",
      "nominal": "Rp 300.000",
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
          content: const PemasukanFilter(),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu-pemasukan'),
        ),
        title: const Text("Semua Pemasukan"),
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
                  'Ringkasan Pemasukan',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Lihat seluruh pemasukan dari berbagai sumber.',
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
                      minWidth: 300,
                      headingRowColor: MaterialStateProperty.all(
                        theme.colorScheme.primary.withOpacity(0.1),
                      ),
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                      columns: const [
                        DataColumn2(label: Text('No'), size: ColumnSize.S),
                        DataColumn2(
                            label: Text('Nama'), size: ColumnSize.L),
                        DataColumn2(
                          label: Text('Nominal'),
                          numeric: true,
                          size: ColumnSize.L,
                        ),
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
                            DataCell(Text(item['no']!)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
