// lib/screens/Pemasukan/kategori_iuran.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pemasukan/add_iuran_dialog.dart';
import '../../widgets/pemasukan/iuran_table.dart';

class KategoriIuran extends StatefulWidget {
  const KategoriIuran({super.key});

  @override
  State<KategoriIuran> createState() => _KategoriIuranState();
}

class _KategoriIuranState extends State<KategoriIuran> {
  // Data dummy tanpa tanggal
  final List<Map<String, String>> _kategoriIuran = [
    {
      "no": "1",
      "nama": "Iuran Warga",
      "jenis": "Iuran Bulanan",
      "nominal": "Rp 10.000",
    },
    {
      "no": "2",
      "nama": "Sumbangan Acara",
      "jenis": "Iuran Khusus",
      "nominal": "Rp 20.000",
    },
    {
      "no": "3",
      "nama": "Sewa Lapangan",
      "jenis": "Iuran Khusus",
      "nominal": "Rp 10.000",
    },
  ];

  void _showAddIuranDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddIuranDialog(
          onIuranAdded: (newIuran) {
            _addNewIuran(newIuran);
          },
        );
      },
    );
  }

  void _addNewIuran(Map<String, String> newIuran) {
    setState(() {
      _kategoriIuran.add({
        "no": (_kategoriIuran.length + 1).toString(),
        "nama": newIuran['nama']!,
        "jenis": newIuran['jenis']!,
        "nominal": newIuran['nominal'] ?? "Rp 0",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Iuran ${newIuran['nama']} berhasil ditambahkan"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteIuran(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Iuran"),
          content: Text("Yakin ingin menghapus iuran ${item['nama']}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _kategoriIuran.remove(item);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text("Iuran ${item['nama']} berhasil dihapus"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Hapus",
                style: TextStyle(color: Colors.white),
              ),
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
        title: const Text("Kategori Iuran"),
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
                  'Kategori Iuran',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola jenis iuran dan nominal yang berlaku di lingkungan.',
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
                    child: IuranTable(
                      kategoriIuran: _kategoriIuran,
                      onAddPressed: _showAddIuranDialog,
                      onDeletePressed: _deleteIuran,
                      onViewPressed: (item) {
                        context.push('/detail-kategori', extra: item);
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
