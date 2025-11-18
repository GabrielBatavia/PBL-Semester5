// lib/screens/Pemasukan/tagihan_table.dart

import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class TagihanTable extends StatelessWidget {
  final List<Map<String, String>> daftarTagihan;
  final Function(Map<String, String>) onViewPressed;

  const TagihanTable({
    super.key,
    required this.daftarTagihan,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildTableHeader(theme),
        const SizedBox(height: 16),
        _buildDataTable(theme),
      ],
    );
  }

  Widget _buildTableHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Daftar Tagihan",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable(ThemeData theme) {
    return Expanded(
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 300,
        headingRowColor: MaterialStateProperty.all(
          theme.colorScheme.primary.withOpacity(0.1),
        ),
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.secondary,
        ),
        columns: const [
          DataColumn2(label: Text('No'), size: ColumnSize.S),
          DataColumn2(label: Text('Nama Keluarga'), size: ColumnSize.L),
          DataColumn2(
            label: Text('Nominal'),
            numeric: true,
            size: ColumnSize.L,
          ),
          DataColumn2(label: Text('Status'), size: ColumnSize.L),
        ],
        rows: daftarTagihan.map((item) {
          return DataRow2(
            onTap: () => onViewPressed(item),
            cells: [
              DataCell(Text(item['no']!)),
              DataCell(Text(item['namaKeluarga']!)),
              DataCell(
                Text(
                  item['nominal']!,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(Text(item['status']!)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
