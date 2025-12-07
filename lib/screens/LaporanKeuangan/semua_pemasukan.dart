// lib/screens/LaporanKeuangan/semua_pemasukan.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/income_transaction_service.dart';
import 'package:jawaramobile_1/widgets/Pemasukan_filter.dart';

class Pemasukan extends StatefulWidget {
  const Pemasukan({super.key});

  @override
  State<Pemasukan> createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactions = await IncomeTransactionService.getIncomeTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp 0';

    final numAmount =
        amount is double ? amount : double.tryParse(amount.toString()) ?? 0;
    final intAmount = numAmount.toInt();

    String numStr = intAmount.toString();
    String result = '';
    int counter = 0;

    for (int i = numStr.length - 1; i >= 0; i--) {
      if (counter == 3) {
        result = '.$result';
        counter = 0;
      }
      result = numStr[i] + result;
      counter++;
    }

    return 'Rp $result';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Pemasukan"),
          content: const SingleChildScrollView(child: PemasukanFilter()),
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
        title: const Text("Semua Pemasukan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTransactions,
          ),
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
                  'Daftar Pemasukan',
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Semua arus kas masuk kampung dalam satu tabel.',
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
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _errorMessage != null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline,
                                          size: 64, color: Colors.red),
                                      const SizedBox(height: 16),
                                      Text('Gagal memuat data',
                                          style: theme.textTheme.titleLarge),
                                      const SizedBox(height: 8),
                                      Text(_errorMessage!,
                                          textAlign: TextAlign.center),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        onPressed: _loadTransactions,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Coba Lagi'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _transactions.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.inbox_outlined,
                                            size: 64, color: Colors.grey[400]),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Belum ada data pemasukan',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _transactions.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final transaction = _transactions[index];
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 12),
                                        onTap: () {
                                          context.push(
                                            '/detail-pemasukan-all',
                                            extra: transaction,
                                          );
                                        },
                                        title: Text(
                                          transaction['name'] ?? 'Tanpa Nama',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text(
                                              transaction['type'] ??
                                                  'Tanpa Jenis',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _formatDate(
                                                  transaction['date'] ?? ''),
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          _formatCurrency(
                                              transaction['amount']),
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
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
