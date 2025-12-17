// lib/screens/pengeluaran/detail_pengeluaran_screen.dart

import 'package:flutter/material.dart';

class DetailPengeluaranScreen extends StatelessWidget {
  // Change from Map<String, String> to Map<String, dynamic>
  final Map<String, dynamic> pengeluaranData;

  const DetailPengeluaranScreen({super.key, required this.pengeluaranData});

  // Widget helper untuk membuat baris detail (Label: Value)
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isNominal = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isNominal ? colorScheme.error : colorScheme.onSurface,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Detail Pengeluaran"),
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
                  pengeluaranData['nama']?.toString() ?? '-',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  pengeluaranData['tanggal']?.toString() ?? '-',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          "Nama Pengeluaran",
                          pengeluaranData['nama']?.toString() ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Jenis Pengeluaran",
                          pengeluaranData['kategori']?.toString() ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Nominal",
                          pengeluaranData['nominal']?.toString() ?? 'Rp 0',
                          isNominal: true,
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Tanggal",
                          pengeluaranData['tanggal']?.toString() ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Bukti Pengeluaran',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                // Placeholder untuk gambar bukti
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
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
