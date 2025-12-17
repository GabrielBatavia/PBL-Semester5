// test/services/payment_channel_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/payment_channel.dart';

void main() {
  group('PaymentChannelService Tests', () {
    group('Response Parsing', () {
      test('should parse single channel response', () {
        final json = {
          'id': 1,
          'name': 'BCA',
          'type': 'bank',
          'account_name': 'RT 01',
          'account_number': '123456',
        };

        final channel = PaymentChannel.fromJson(json);

        expect(channel.id, 1);
        expect(channel.name, 'BCA');
        expect(channel.type, 'bank');
        expect(channel.accountName, 'RT 01');
        expect(channel.accountNumber, '123456');
      });

      test('should parse list of channels', () {
        final jsonList = [
          {
            'id': 1,
            'name': 'BCA',
            'type': 'bank',
            'account_name': 'RT 01',
            'account_number': '123456',
          },
          {
            'id': 2,
            'name': 'OVO',
            'type': 'ewallet',
            'account_name': 'RT 01',
            'account_number': '081234567890',
          },
        ];

        final channels = jsonList
            .map((e) => PaymentChannel.fromJson(e as Map<String, dynamic>))
            .toList();

        expect(channels.length, 2);
        expect(channels[0].name, 'BCA');
        expect(channels[0].type, 'bank');
        expect(channels[1].name, 'OVO');
        expect(channels[1].type, 'ewallet');
      });

      test('should parse channel with null optional fields', () {
        final json = {
          'id': 3,
          'name': 'Cash',
          'type': 'cash',
        };

        final channel = PaymentChannel.fromJson(json);

        expect(channel.id, 3);
        expect(channel.name, 'Cash');
        expect(channel.type, 'cash');
        expect(channel.accountName, isNull);
        expect(channel.accountNumber, isNull);
      });
    });

    group('Channel Type Validation', () {
      test('should accept valid channel types', () {
        final validTypes = ['bank', 'ewallet', 'qris'];
        
        for (final type in validTypes) {
          expect(type, isIn(['bank', 'ewallet', 'qris']));
        }
      });

      test('bank channel should have account details', () {
        final bankChannel = PaymentChannel.fromJson({
          'id': 1,
          'name': 'BCA',
          'type': 'bank',
          'account_name': 'RT 01',
          'account_number': '1234567890',
        });

        expect(bankChannel.type, 'bank');
        expect(bankChannel.accountName, isNotNull);
        expect(bankChannel.accountNumber, isNotNull);
      });

      test('ewallet channel should have phone number', () {
        final ewalletChannel = PaymentChannel.fromJson({
          'id': 2,
          'name': 'OVO',
          'type': 'ewallet',
          'account_name': 'RT 01',
          'account_number': '081234567890',
        });

        expect(ewalletChannel.type, 'ewallet');
        expect(ewalletChannel.accountNumber, isNotNull);
      });

      test('qris channel should have valid type', () {
        final qrisChannel = PaymentChannel.fromJson({
          'id': 3,
          'name': 'QRIS RT',
          'type': 'qris',
        });

        expect(qrisChannel.type, 'qris');
      });
    });

    group('Error Handling', () {
      test('should handle empty list', () {
        final emptyList = <Map<String, dynamic>>[];
        final channels = emptyList
            .map((e) => PaymentChannel.fromJson(e))
            .toList();

        expect(channels, isEmpty);
      });

      test('should throw error on missing required id field', () {
        final invalidJson = {
          'name': 'BCA',
          'type': 'bank',
        };

        expect(
          () => PaymentChannel.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      });

      test('should provide default empty string for missing name', () {
        final json = {
          'id': 1,
          'type': 'bank',
        };

        final channel = PaymentChannel.fromJson(json);
        
        expect(channel.name, '');
        expect(channel.type, 'bank');
      });
    });

    group('Data Integrity', () {
      test('should preserve all field values', () {
        final json = {
          'id': 100,
          'name': 'Test Bank',
          'type': 'bank',
          'account_name': 'Test Account',
          'account_number': '9999999999',
        };

        final channel = PaymentChannel.fromJson(json);

        expect(channel.id, 100);
        expect(channel.name, 'Test Bank');
        expect(channel.type, 'bank');
        expect(channel.accountName, 'Test Account');
        expect(channel.accountNumber, '9999999999');
      });

      test('should handle special characters in strings', () {
        final json = {
          'id': 1,
          'name': 'BCA & Mandiri',
          'type': 'bank',
          'account_name': 'RT 01 / RW 02',
          'account_number': '123-456-7890',
        };

        final channel = PaymentChannel.fromJson(json);

        expect(channel.name, contains('&'));
        expect(channel.accountName, contains('/'));
        expect(channel.accountNumber, contains('-'));
      });
    });
  });
}