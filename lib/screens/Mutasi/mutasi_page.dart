// lib/screens/Mutasi/mutasi_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MutasiPage extends StatelessWidget {
  MutasiPage({super.key});

  final List<Map<String, dynamic>> dataMutasi = [
    {
      "no": 1,
      "keluarga": "Keluarga Ijat",
      "tanggal": "15 Oktober 2025",
      "jenis": "Keluar Wilayah",
    },
    {
      "no": 2,
      "keluarga": "Keluarga Mara Nunez",
      "tanggal": "30 September 2025",
      "jenis": "Pindah Rumah",
    },
    {
      "no": 3,
      "keluarga": "Keluarga Ijat",
      "tanggal": "24 Oktober 2026",
      "jenis": "Pindah Rumah",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text("Daftar Mutasi Warga"),
        centerTitle: true,
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mutasi Warga',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Catat perpindahan rumah maupun keluar/masuk wilayah.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth,
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
                      child: DataTableTheme(
                        data: DataTableThemeData(
                          headingRowColor: MaterialStateProperty.all(
                            colorScheme.primary.withOpacity(0.05),
                          ),
                          dataRowColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 0,
                            horizontalMargin: 16,
                            headingTextStyle: theme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                            columns: const [
                              DataColumn(label: Text("No")),
                              DataColumn(label: Text("Nama Keluarga")),
                              DataColumn(label: Text("Aksi")),
                            ],
                            rows: dataMutasi.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(item['no'].toString())),
                                  DataCell(Text(item['keluarga'])),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.eye,
                                          size: 18,
                                          color: Colors.blueGrey,
                                        ),
                                        tooltip: 'Lihat Detail',
                                        onPressed: () {
                                          context.pushNamed(
                                            'mutasi-detail',
                                            extra: item,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
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
  }
}
