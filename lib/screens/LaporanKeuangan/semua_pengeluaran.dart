// lib/screens/LaporanKeuangan/semua_pengeluaran.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/utils/safe_navigation.dart';
import 'package:jawaramobile_1/widgets/pengeluaran_filter.dart';
import 'package:jawaramobile_1/services/expenses_service.dart';

class Pengeluaran extends StatefulWidget {
  const Pengeluaran({super.key});

  @override
  State<Pengeluaran> createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  List<Map<String, dynamic>> _pengeluaranData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      final data = await ExpenseService.getExpenses();
      setState(() {
        _pengeluaranData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Pengeluaran"),
          content: const SingleChildScrollView(child: PengeluaranFilter()),
          actions: <Widget>[
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Cari"),
              onPressed: () {
                // TODO: Tambahkan logika filter
                Navigator.of(context).pop();
              },
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
        title: const Text("Semua Pengeluaran"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
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
                  'Daftar Pengeluaran',
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pantau semua pengeluaran kas RT/RW secara transparan.',
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _pengeluaranData.isEmpty
                              ? const Center(
                                  child: Text('Tidak ada data pengeluaran'),
                                )
                              : DataTable2(
                                  columnSpacing: 12,
                                  horizontalMargin: 12,
                                  headingRowHeight: 56,
                                  dataRowHeight: 56,
                                  headingRowColor: MaterialStateProperty.all(
                                    colorScheme.primary.withOpacity(0.05),
                                  ),
                                  headingTextStyle: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                  columns: const [
                                    DataColumn2(label: Text('Nama'), size: ColumnSize.L),
                                    DataColumn2(label: Text('Nominal'), numeric: true),
                                  ],
                                  rows: _pengeluaranData.map((item) {
                                    return DataRow2(
                                      onTap: () {
                                        context.safePush(
                                          '/detail-pengeluaran-all',
                                          extra: item,
                                        );
                                      },
                                      cells: [
                                        DataCell(Text(item['name']?.toString() ?? '-')),
                                        DataCell(
                                          Text(
                                            'Rp ${item['amount']?.toString() ?? '0'}',
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
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