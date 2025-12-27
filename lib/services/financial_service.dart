// lib/services/financial_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/financial_model.dart';

class FinancialService {
  static const _cacheKey = 'rt_financial_transactions_cache';

  // =============================================================
  // #14 SIMULASI RESTful API (Async)
  // =============================================================

  Future<List<Transaction>> fetchTransactionsFromApi() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Transaction(
        id: 'T1',
        description: 'Iuran Kas Bulan Ini',
        amount: 100000,
        type: TransactionType.income,
        date: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Transaction(
        id: 'T2',
        description: 'Pembelian Peralatan Bersih',
        amount: 25000,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      Transaction(
        id: 'T3',
        description: 'Donasi Bantuan Bencana',
        amount: 50000,
        type: TransactionType.income,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 'T4',
        description: 'Biaya Konsumsi Rapat',
        amount: 35000,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> postTransaction(Transaction newTransaction) async {
    await Future.delayed(const Duration(seconds: 2));

    final currentTransactions = await getTransactions();
    currentTransactions.insert(0, newTransaction);

    await saveTransactionsToCache(currentTransactions);
    print('DEBUG: Transaksi sukses diposting dan di-cache!');
  }

  // =============================================================
  // #13 PERSISTENSI (SharedPreferences)
  // =============================================================

  Future<void> saveTransactionsToCache(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_cacheKey, json.encode(jsonList));
  }

  Future<List<Transaction>> getTransactionsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => Transaction.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Transaction>> getTransactions() async {
    final cached = await getTransactionsFromCache();
    if (cached.isNotEmpty) {
      print('DEBUG: Memuat dari Cache Lokal...');
      return cached;
    }

    print('DEBUG: Cache kosong, memuat dari API...');
    final apiData = await fetchTransactionsFromApi();
    await saveTransactionsToCache(apiData);
    return apiData;
  }

  Future<double> calculateBalance(List<Transaction> transactions) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    return income - expense;
  }

  Future<List<PaymentChannel>> getPaymentChannels() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      PaymentChannel(
        id: '1',
        bankName: 'Bank Mandiri',
        accountNumber: '1234-567-890',
        accountHolder: 'Bendahara RT 01',
      ),
      PaymentChannel(
        id: '2',
        bankName: 'Gopay',
        accountNumber: '0812-345-678',
        accountHolder: 'Bendahara RT 01',
      ),
      PaymentChannel(
        id: '3',
        bankName: 'BCA',
        accountNumber: '987-654-321',
        accountHolder: 'Kas Umum RT',
      ),
    ];
  }
}
