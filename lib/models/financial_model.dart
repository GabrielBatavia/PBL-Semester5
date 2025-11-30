import 'dart:convert';

// Enum tipe transaksi
enum TransactionType { income, expense }

// =============================================================
// Model Transaksi
// =============================================================
class Transaction {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });

  // Convert JSON → Object
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: DateTime.parse(json['date']),
    );
  }

  // Convert Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'date': date.toIso8601String(),
    };
  }
}

// =============================================================
// Model Channel Pembayaran
// =============================================================
class PaymentChannel {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountHolder;

  PaymentChannel({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
  });

  factory PaymentChannel.fromJson(Map<String, dynamic> json) {
    return PaymentChannel(
      id: json['id'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountHolder: json['accountHolder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
    };
  }
}
