// test/models/payment_channel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/payment_channel.dart';

void main() {
  group('PaymentChannel Model Tests', () {
    test('fromJson should parse complete data correctly', () {
      final json = {
        'id': 1,
        'name': 'BCA Transfer',
        'type': 'bank',
        'account_name': 'RT 01 RW 02',
        'account_number': '1234567890',
      };

      final channel = PaymentChannel.fromJson(json);

      expect(channel.id, 1);
      expect(channel.name, 'BCA Transfer');
      expect(channel.type, 'bank');
      expect(channel.accountName, 'RT 01 RW 02');
      expect(channel.accountNumber, '1234567890');
    });

    test('fromJson should handle null accountName and accountNumber', () {
      final json = {
        'id': 2,
        'name': 'Cash',
        'type': 'cash',
        'account_name': null,
        'account_number': null,
      };

      final channel = PaymentChannel.fromJson(json);

      expect(channel.id, 2);
      expect(channel.name, 'Cash');
      expect(channel.type, 'cash');
      expect(channel.accountName, isNull);
      expect(channel.accountNumber, isNull);
    });

    test('fromJson should handle missing optional fields', () {
      final json = {
        'id': 3,
        'name': 'OVO',
        'type': 'ewallet',
      };

      final channel = PaymentChannel.fromJson(json);

      expect(channel.id, 3);
      expect(channel.name, 'OVO');
      expect(channel.type, 'ewallet');
      expect(channel.accountName, isNull);
      expect(channel.accountNumber, isNull);
    });

    test('fromJson should provide default values for missing name/type', () {
      final json = {
        'id': 4,
      };

      final channel = PaymentChannel.fromJson(json);

      expect(channel.id, 4);
      expect(channel.name, '');
      expect(channel.type, '');
    });

    test('constructor should create object with required fields', () {
      final channel = PaymentChannel(
        id: 5,
        name: 'Mandiri',
        type: 'bank',
      );

      expect(channel.id, 5);
      expect(channel.name, 'Mandiri');
      expect(channel.type, 'bank');
      expect(channel.accountName, isNull);
      expect(channel.accountNumber, isNull);
    });

    test('constructor should create object with all fields', () {
      final channel = PaymentChannel(
        id: 6,
        name: 'BRI',
        type: 'bank',
        accountName: 'Bendahara RT',
        accountNumber: '9876543210',
      );

      expect(channel.id, 6);
      expect(channel.name, 'BRI');
      expect(channel.type, 'bank');
      expect(channel.accountName, 'Bendahara RT');
      expect(channel.accountNumber, '9876543210');
    });

    test('should handle different channel types', () {
      final bankChannel = PaymentChannel.fromJson({
        'id': 7,
        'name': 'BCA',
        'type': 'bank',
      });

      final ewalletChannel = PaymentChannel.fromJson({
        'id': 8,
        'name': 'GoPay',
        'type': 'ewallet',
      });

      final qrisChannel = PaymentChannel.fromJson({
        'id': 9,
        'name': 'QRIS RT',
        'type': 'qris',
      });

      expect(bankChannel.type, 'bank');
      expect(ewalletChannel.type, 'ewallet');
      expect(qrisChannel.type, 'qris');
    });
  });
}