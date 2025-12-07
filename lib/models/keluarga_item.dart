import 'package:flutter/material.dart';

class KeluargaListItem extends StatelessWidget {
  final String namaKeluarga;
  final int jumlahAnggota;
  final String alamat;

  const KeluargaListItem({
    super.key,
    required this.namaKeluarga,
    required this.jumlahAnggota,
    required this.alamat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildTextInfo(String label, String value, {Color? valueColor}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Kolom kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextInfo("Nama Keluarga", namaKeluarga),
                  const SizedBox(height: 12),
                  buildTextInfo("Jumlah Anggota", jumlahAnggota.toString()),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Kolom kanan
            buildTextInfo(
              "Alamat",
              alamat,
              valueColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
