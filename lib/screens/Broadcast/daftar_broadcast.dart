// lib/screens/Broadcast/daftar_broadcast.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/widgets/broadcast/broadcast_filter.dart';

class BroadcastScreen extends StatelessWidget {
  const BroadcastScreen({super.key});

  // Data dummy
  final List<Map<String, String>> _broadcastData = const [
    {
      "pengirim": "Ahmad Suhendra",
      "judul": "Pemberitahuan Kerja Bakti",
      "isi":
          "Halo warga RT 05, pada Sabtu mendatang akan diadakan kerja bakti membersihkan lingkungan. Mohon partisipasinya ya!",
      "tanggal": "18 Okt 2025",
    },
    {
      "pengirim": "Siti Aminah",
      "judul": "Undangan Rapat Warga",
      "isi":
          "Yth. Warga RT 05, kami mengundang Anda untuk hadir dalam rapat warga yang akan dilaksanakan pada Minggu, 20 Oktober 2025 di Balai Warga pukul 10.00 WIB.",
      "tanggal": "18 Okt 2025",
    },
  ];

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Broadcast"),
          content: const SingleChildScrollView(child: BroadcastFilter()),
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
        title: const Text("Broadcast"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tambah-broadcast'),
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
                  'Daftar Broadcast',
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola pengumuman resmi untuk seluruh warga.',
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
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                        columns: const [
                          DataColumn2(label: Text('Judul')),
                          DataColumn2(label: Text('Pengirim')),
                        ],
                        rows: _broadcastData.map((item) {
                          return DataRow2(
                            onTap: () {
                              context.push(
                                '/detail-broadcast',
                                extra: item,
                              );
                            },
                            cells: [
                              DataCell(
                                Text(
                                  item['judul']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(Text(item['pengirim']!)),
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
