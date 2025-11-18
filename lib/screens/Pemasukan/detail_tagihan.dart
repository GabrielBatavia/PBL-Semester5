// lib/screens/Pemasukan/detail_tagihan.dart

import 'package:flutter/material.dart';

class DetailTagihan extends StatelessWidget {
  // Data Tagihan diterima melalui constructor
  final Map<String, String> kategoriData;

  const DetailTagihan({super.key, required this.kategoriData});

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
                color: isNominal ? Colors.green[700] : colorScheme.onSurface,
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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Detail Tagihan"),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
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
                  kategoriData['namaKeluarga'] ?? '-',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  kategoriData['statusKeluarga'] ?? '-',
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
                          "Nama Keluarga",
                          kategoriData['namaKeluarga'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Status Keluarga",
                          kategoriData['statusKeluarga'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Jenis Iuran",
                          kategoriData['jenis'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Kode Tagihan",
                          kategoriData['kodeTagihan'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Nominal",
                          kategoriData['nominal'] ?? 'Rp 0',
                          isNominal: true,
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Periode",
                          kategoriData['periode'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Status",
                          kategoriData['status'] ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Bukti Tagihan',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
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
