// lib/screens/DataWargaRumah/tabel_rumah.dart

import 'package:flutter/material.dart';

class TabelRumah extends StatelessWidget {
  const TabelRumah({super.key});

  final List<Map<String, dynamic>> rumah = const [
    {
      "alamat": "Jl. Melati No.10",
      "luas": "120 m²",
      "status": "Milik Sendiri"
    },
    {
      "alamat": "Jl. Mawar No.7",
      "luas": "90 m²",
      "status": "Kontrak"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tabel Data Rumah",
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: MaterialStateProperty.all(
                  colorScheme.primary.withOpacity(0.06),
                ),
                headingTextStyle: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                columns: const [
                  DataColumn(label: Text("Alamat")),
                  DataColumn(label: Text("Luas")),
                  DataColumn(label: Text("Status")),
                ],
                rows: rumah.map((r) {
                  final isMilikSendiri = r["status"] == "Milik Sendiri";
                  final bgColor = isMilikSendiri
                      ? Colors.green.shade50
                      : Colors.orange.shade50;
                  final fgColor = isMilikSendiri
                      ? Colors.green.shade800
                      : Colors.orange.shade800;

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          r["alamat"],
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      DataCell(
                        Text(
                          r["luas"],
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            r["status"],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: fgColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
