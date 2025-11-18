// lib/screens/Kegiatan/daftar_kegiatan.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/widgets/kegiatan/kegiatan_filter.dart';

class KegiatanScreen extends StatelessWidget {
  const KegiatanScreen({super.key});

  // Data dummy
  final List<Map<String, String>> _kegiatanData = const [
    {
      "nama": "Kerja Bakti Bulanan",
      "kategori": "Kebersihan & Keamanan",
      "pj": "Pak RT",
      "tanggal": "21 Oktober 2025",
      "lokasi": "Lingkungan RT 05",
      "deskripsi": "Membersihkan selokan dan area umum.",
    },
    {
      "nama": "Rapat Karang Taruna",
      "kategori": "Komunitas & Sosial",
      "pj": "Ketua Karang Taruna",
      "tanggal": "10 Oktober 2025",
      "lokasi": "Balai Desa Kidal",
      "deskripsi":
          "Pembubaran panitia PHBN sekaligus membahas rencana kegiatan akhir tahun.",
    },
    {
      "nama": "Jalan Sehat",
      "kategori": "Kesehatan & Olahraga",
      "pj": "Karang Taruna",
      "tanggal": "30 September 2025",
      "lokasi": "Lapangan SD Negeri Kidal",
      "deskripsi": "Jalan sehat, senam, dan pembagian doorprize.",
    },
    {
      "nama": "Upacara 17 Agustus",
      "kategori": "Komunitas & Sosial",
      "pj": "Karang Taruna",
      "tanggal": "17 Agustus 2025",
      "lokasi": "Candi Kidal",
      "deskripsi":
          "Upacara peringatan detik-detik proklamasi kemerdekaan Republik Indonesia.",
    },
    {
      "nama": "Seminar Warga",
      "kategori": "Pendidikan",
      "pj": "Kepala Desa",
      "tanggal": "17 Juli 2025",
      "lokasi": "Balai Desa Kidal",
      "deskripsi": "Seminar tentang bahaya judi online.",
    },
  ];

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Kegiatan"),
          content: const SingleChildScrollView(child: KegiatanFilter()),
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Konfirmasi Hapus"),
          content: const Text(
            "Apakah Anda yakin ingin menghapus kegiatan ini? Aksi ini tidak dapat dibatalkan.",
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text("Hapus"),
              onPressed: () {
                // TODO: implement delete
                Navigator.of(dialogContext).pop();
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kegiatan berhasil dihapus')),
                );
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
        title: const Text("Kegiatan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tambah-kegiatan'),
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
                  'Daftar Kegiatan',
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pantau seluruh agenda kampung dalam satu tampilan.',
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
                          DataColumn2(label: Text('Nama Kegiatan')),
                          DataColumn2(label: Text('Tanggal')),
                        ],
                        rows: _kegiatanData.map((item) {
                          return DataRow2(
                            onTap: () {
                              context.push('/detail-kegiatan', extra: item);
                            },
                            cells: [
                              DataCell(
                                Text(
                                  item['nama']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(Text(item['tanggal']!)),
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
