import 'package:flutter/material.dart';

import '../models/financial_model.dart';
import '../services/financial_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _service = FinancialService();

  double _totalBalance = 0.0;
  List<Transaction> _recentTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _service.getTransactions();

      double balance = 0.0;
      for (var tx in transactions) {
        balance += tx.type == TransactionType.income
            ? tx.amount
            : -tx.amount;
      }

      setState(() {
        _totalBalance = balance;
        _recentTransactions = transactions.reversed.take(10).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Gagal memuat laporan: $e"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _balanceColor() {
    if (_totalBalance > 0) return Colors.green;
    if (_totalBalance < 0) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadReportData,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // -------------------------
                // CARD SALDO TOTAL
                // -------------------------
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Saldo Kas RT/RW",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Rp ${_totalBalance.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _balanceColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // -------------------------
                // LOG TRANSAKSI TERBARU
                // -------------------------
                const Text(
                  "Log Transaksi Terbaru",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                if (_recentTransactions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Belum ada transaksi tercatat.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ..._recentTransactions.map((tx) {
                    final isIncome = tx.type == TransactionType.income;
                    final icon = isIncome ? Icons.add : Icons.remove;
                    final iconColor = isIncome ? Colors.green : Colors.red;
                    final sign = isIncome ? "+" : "-";

                    final formattedDate =
                        "${tx.date.day}/${tx.date.month}/${tx.date.year} ${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')}";

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: iconColor.withOpacity(0.2),
                        child: Icon(icon, color: iconColor),
                      ),
                      title: Text(tx.description),
                      subtitle: Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        "$sign Rp ${tx.amount.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
