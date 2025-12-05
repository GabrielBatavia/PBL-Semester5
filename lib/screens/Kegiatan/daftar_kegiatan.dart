// lib/screens/Kegiatan/daftar_kegiatan.dart

import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/kegiatan_service.dart';
import 'package:jawaramobile_1/widgets/kegiatan/kegiatan_filter.dart';
import 'package:jawaramobile_1/utils/session.dart';

class KegiatanScreen extends StatefulWidget {
  const KegiatanScreen({super.key});

  @override
  State<KegiatanScreen> createState() => _KegiatanScreenState();
}

class _KegiatanScreenState extends State<KegiatanScreen> {
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController.broadcast();

  List<Map<String, dynamic>> _kegiatanList = [];

  @override
  void initState() {
    super.initState();
    _loadKegiatan();
  }

  Future<void> _loadKegiatan() async {
    try {
      final int userId = await Session.getUserId();
      final String role = await Session.getUserRole();

      final raw = await KegiatanService.getKegiatanByRole(
        userId: userId,
        role: role,
      );

      _kegiatanList = raw.map((e) => Map<String, dynamic>.from(e)).toList();
      _streamController.add(_kegiatanList);
    } catch (e) {
      _streamController.add([]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat kegiatan: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Filter Kegiatan"),
        content: const SingleChildScrollView(child: KegiatanFilter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cari"),
          ),
        ],
      ),
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
                  style:
                      theme.textTheme.displayLarge!.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final data = snapshot.data!;
                        if (data.isEmpty) {
                          return const Center(
                            child: Text("Tidak ada kegiatan"),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: DataTable2(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            headingRowColor: MaterialStateProperty.all(
                              colorScheme.primary.withOpacity(0.05),
                            ),
                            headingTextStyle:
                                theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                            columns: const [
                              DataColumn2(label: Text('Nama Kegiatan')),
                              DataColumn2(label: Text('Tanggal')),
                            ],
                            rows: data.map((item) {
                              return DataRow2(
                                onTap: () => context.push(
                                  '/detail-kegiatan',
                                  extra: item,
                                ),
                                cells: [
                                  DataCell(Text(item['name'] ?? "-")),
                                  DataCell(Text(item['date'] ?? "-")),
                                ],
                              );
                            }).toList(),
                          ),
                        );
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