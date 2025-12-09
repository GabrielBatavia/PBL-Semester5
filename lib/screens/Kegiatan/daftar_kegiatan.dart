// lib/screens/Kegiatan/daftar_kegiatan.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/kegiatan.dart';
import '../../services/kegiatan_service.dart';
import '../../widgets/kegiatan/kegiatan_filter.dart';

class KegiatanScreen extends StatefulWidget {
  const KegiatanScreen({super.key});

  @override
  State<KegiatanScreen> createState() => _KegiatanScreenState();
}

class _KegiatanScreenState extends State<KegiatanScreen> {
  late Future<List<Kegiatan>> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  /// reload data dari API
  Future<void> _reload() async {
    _futureKegiatan = KegiatanService.instance.fetchKegiatan();
    setState(() {});
  }

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
                // TODO: tambahkan filter ke fetchKegiatan kalau mau
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Format tanggal dari DateTime → "17 Agustus 2025"
  String _formatTanggal(DateTime d) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${d.day} ${bulan[d.month - 1]} ${d.year}';
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
                      child: FutureBuilder<List<Kegiatan>>(
                        future: _futureKegiatan,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          final data = snapshot.data ?? [];

                          if (data.isEmpty) {
                            return const Center(
                              child: Text('Belum ada kegiatan tercatat.'),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: _reload,
                            child: ListView.builder(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                final tanggal =
                                    _formatTanggal(item.tanggal);

                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    title: Text(
                                      item.nama,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(tanggal),
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      context.push(
                                        '/detail-kegiatan',
                                        extra: {
                                          'id': item.id.toString(),
                                          'nama': item.nama,
                                          'kategori': item.kategori ?? '',
                                          'pj': item.pj ?? '',
                                          'lokasi': item.lokasi ?? '',
                                          'tanggal': tanggal,
                                          'deskripsi':
                                              item.deskripsi ?? '',
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
