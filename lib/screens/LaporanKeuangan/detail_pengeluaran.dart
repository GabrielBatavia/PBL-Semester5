// lib/screens/LaporanKeuangan/detail_pengeluaran.dart

import 'package:flutter/material.dart';

class DetailPengeluaran extends StatelessWidget {
  final Map<String, String> pengeluaranData;

  const DetailPengeluaran({super.key, required this.pengeluaranData});

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isNominal = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isNominal
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Detail Pengeluaran"),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  pengeluaranData['nama'] ?? '-',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  pengeluaranData['kategori'] ?? '',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.98),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 18,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          "Nama Pengeluaran",
                          pengeluaranData['nama'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Jenis Pengeluaran",
                          pengeluaranData['kategori'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Nominal",
                          pengeluaranData['nominal'] ?? 'Rp 0',
                          isNominal: true,
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Tanggal",
                          pengeluaranData['tanggal'] ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Bukti Pengeluaran',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 44,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
