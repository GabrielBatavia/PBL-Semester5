// lib/models/payment_channel.dart

class PaymentChannel {
  final int id;
  final String name;
  final String type;           // bank / ewallet / qris
  final String? accountName;   // A/N
  final String? accountNumber; // no rek / no ewallet

  PaymentChannel({
    required this.id,
    required this.name,
    required this.type,
    this.accountName,
    this.accountNumber,
  });

  factory PaymentChannel.fromJson(Map<String, dynamic> json) {
    return PaymentChannel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      accountName: json['account_name'] as String?,
      accountNumber: json['account_number'] as String?,
    );
  }
}
