import 'package:flutter/material.dart';

import 'report_screen.dart';
import 'income_screen.dart';
import 'expense_screen.dart';
import 'channel_screen.dart';

// Halaman utama Modul Bendahara dengan Tab Navigation
class FinancialScreen extends StatelessWidget {
  static const Key tabControllerKey = Key('financialTabController');

  const FinancialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      key: tabControllerKey,
      length: 4,
      initialIndex: 0, // Default ke Laporan Keuangan
      child: Scaffold(
        appBar: AppBar(
          title: const Text('💰 Modul Bendahara RT'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Laporan',
                icon: Icon(Icons.analytics),
              ),
              Tab(
                text: 'Pemasukan',
                icon: Icon(Icons.arrow_downward),
              ),
              Tab(
                text: 'Pengeluaran',
                icon: Icon(Icons.arrow_upward),
              ),
              Tab(
                text: 'Channel',
                icon: Icon(Icons.account_balance),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReportScreen(),   // Laporan Keuangan & Saldo
            IncomeScreen(),   // Form Input Pemasukan
            ExpenseScreen(),  // Form Input Pengeluaran
            ChannelScreen(),  // Channel Transfer
          ],
        ),
      ),
    );
  }
}
