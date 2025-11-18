// lib/screens/Mutasi/mutasi_detail_page.dart

import 'package:flutter/material.dart';

class MutasiDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const MutasiDetailPage({super.key, required this.data});

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
        title: const Text("Detail Mutasi Warga"),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  data['keluarga'] ?? '-',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  data['jenis'] ?? '',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.97),
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
                      horizontal: 16,
                      vertical: 18,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          "Keluarga",
                          data['keluarga'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Alamat Lama",
                          data['alamatLama'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Alamat Baru",
                          data['alamatBaru'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Tanggal Mutasi",
                          data['tanggal'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Jenis Mutasi",
                          data['jenis'] ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Alasan",
                          data['alasan'] ?? '-',
                        ),
                      ],
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
